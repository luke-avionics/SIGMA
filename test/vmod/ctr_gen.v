`timescale 1ns / 1ps
module ctr_gen # (
	parameter I_ROW_SIZE = 4,
	parameter I_COL_SIZE = 8,
    parameter W_ROW_SIZE = 8,
    parameter W_COL_SIZE = 4,
    parameter LOG2_W_ROW_SIZE = 3,
    parameter LOG2_W_COL_SIZE = 2,
    parameter LOG2_I_ROW_SIZE = 2,
    parameter LOG2_I_COL_SIZE = 3,
    parameter I_BUFF_SIZE = 32,
    parameter W_BUFF_SIZE = 32,
	parameter DATA_TYPE =  32 ,
	parameter NUM_PES =  32 ,
    parameter LOG2_PES =  5 ,
    parameter LOG2_W_BUFF_SIZE =  5  
)(
	clk,
	rst,
    i_valid,
    i_bit_map,
    i_nonzero_ele,
    w_valid,
    w_bit_map,
    w_nonzero_ele,
    done_computing_one_tile,
    stationary_buffer,
    output_bit_map    
); 
// currently assuming no evil row skipping for the streaming matrix
// currently also assuming non-zero elements can be stuffed to one flexdpe
//  ---- due to the under-utilization issue


	input clk;
	input rst;
    input i_valid;
    input i_bit_map[I_ROW_SIZE-1:0][I_COL_SIZE-1:0];
    input [DATA_TYPE-1:0]i_nonzero_ele[I_BUFF_SIZE-1:0];
    input w_valid;
    input w_bit_map[W_ROW_SIZE-1:0][W_COL_SIZE-1:0];
    input [DATA_TYPE-1:0]w_nonzero_ele[W_BUFF_SIZE-1:0];
    input done_computing_one_tile;
    output reg [DATA_TYPE-1:0]stationary_buffer[NUM_PES-1:0];
    output reg output_bit_map[W_ROW_SIZE-1:0][I_COL_SIZE-1:0];


    reg row_wise_or[I_ROW_SIZE-1:0];
    reg stationary_bit_map[W_ROW_SIZE-1:0][W_COL_SIZE-1:0];
    reg [5:0]tile_counter;

    reg [LOG2_W_ROW_SIZE-1:0]w_row_counter;
    reg [LOG2_W_COL_SIZE-1:0]w_col_counter;
    reg [LOG2_W_BUFF_SIZE-1:0]w_nonzero_counter;

    reg [LOG2_I_ROW_SIZE-1:0]i_row_counters[I_COL_SIZE-1:0];
    reg [LOG2_I_ROW_SIZE-1:0]i_nonzero_counters[I_COL_SIZE-1:0];


    //use multiple source destination tables for latency reduction
    //otherwise, for each column of the streaming input, it has to hold and wait
    reg [LOG2_W_ROW_SIZE-1:0]sd_table_id[I_COL_SIZE-1:0][NUM_PES-1:0];
    reg [LOG2_I_ROW_SIZE-1:0]sd_table_src[I_COL_SIZE-1:0][NUM_PES-1:0];
    reg [LOG2_W_BUFF_SIZE-1:0]sd_table_dest[I_COL_SIZE-1:0][NUM_PES-1:0];


    reg [LOG2_PES-1:0]sd_table_entry_counter[I_COL_SIZE-1:0];

    reg slice1[W_COL_SIZE-1:0];
    reg slice2[W_COL_SIZE-1:0];


    genvar i,j,k;
    
    

    // spatial and expensive way to generate the output bitmap
    generate
        for (i = 0; i < W_ROW_SIZE; i = i + 1) begin:for_i1
            for (j = 0; j < I_COL_SIZE; j = j + 1) begin:for_j1
                always @(posedge clk) begin
                    output_bit_map[i][j] <= (w_bit_map[i][0] & i_bit_map[0][j]) | (w_bit_map[i][1] & i_bit_map[1][j]) | (w_bit_map[i][2] & i_bit_map[2][j]) | (w_bit_map[i][3] & i_bit_map[3][j]);
                end
            end
        end
    endgenerate

    // see if there is evil row in the streaming matrix
    generate
        for (j = 0; j < I_ROW_SIZE; j = j + 1) begin:for_j2
            always @(posedge clk) begin
                row_wise_or[j] <= i_bit_map[j][0] | i_bit_map[j][1] | i_bit_map[j][2] | i_bit_map[j][3];
            end
        end
    endgenerate

    // element wise and
    generate
        for (i = 0; i < W_ROW_SIZE; i = i + 1) begin:for_i3
            for (k = 0; k < W_COL_SIZE; k = k + 1) begin:for_k3
                always @(posedge clk) begin
                    stationary_bit_map[i][k] <= row_wise_or[k] & w_bit_map[i][k];
                end
            end
        end      
    endgenerate

    // pipe the stationary buffer
    // TODO: no skipping of the just generated stationary bit map
    generate
        for (j = 0; j < NUM_PES; j = j + 1) begin:for_i4
            always @(posedge clk ) begin
                stationary_buffer[j] <= w_nonzero_ele[j];
            end  
        end
    endgenerate



 
    always @(posedge clk) begin
        if(rst) begin
            w_row_counter <= 0;
            w_col_counter <= 0;
        end else begin
            if(w_col_counter == W_COL_SIZE-1) begin
                w_col_counter <= 0;
                if(w_row_counter == W_ROW_SIZE-1) begin
                    w_row_counter <= 0;
                end else begin
                    w_row_counter <= w_row_counter + 1;
                end

            end else begin
                w_col_counter <= w_col_counter + 1;
                w_row_counter <= w_row_counter;
            end
        end
    end


    generate
        for (i = 0; i < I_COL_SIZE; i = i + 1) begin:for_i5
            always @(posedge clk) begin
                if(rst) begin
                    i_row_counters[i] <= 0; 
                end else begin
                    i_row_counters[i] <= i_row_counters[i] + 1;                
                end
            end
        end
    endgenerate

    always @(posedge clk) begin
        if(rst) begin
            w_nonzero_counter <= 0;
        end else begin
            if(stationary_bit_map[w_row_counter][w_col_counter] == 1)begin
                w_nonzero_counter <= w_nonzero_counter + 1;       
            end else begin
                w_nonzero_counter <= w_nonzero_counter;
            end
        end
    end

    generate
        for (i = 0; i < I_COL_SIZE; i = i + 1) begin
            always @(posedge clk) begin
                if(rst) begin
                    i_nonzero_counters[i] <= 0;
                end else begin
                    if(i_bit_map[i_row_counters[i]][i] == 1) begin
                        i_nonzero_counters[i] <= i_nonzero_counters[i] + 1;
                    end else begin
                        i_nonzero_counters[i] <= i_nonzero_counters[i];
                    end
                end
            end
        end
    endgenerate

    generate
        for (i = 0; i < I_COL_SIZE; i = i + 1) begin:for_i6
            //generate src dest table entries
            always @(posedge clk) begin
                if(rst) begin
                    sd_table_entry_counter[i] <= 0;
                end else begin
                    if(stationary_bit_map[w_row_counter][w_col_counter] == 1 && i_bit_map[i_row_counters[i]][i] == 1)begin
                        sd_table_entry_counter[i] <= sd_table_entry_counter[i] + 1;
                        sd_table_id[i][sd_table_entry_counter[i]] <= w_row_counter;
                        sd_table_src[i][sd_table_entry_counter[i]] <= i_nonzero_counters[i];
                        sd_table_dest[i][sd_table_entry_counter[i]] <= w_nonzero_counter;
                    end else begin
                        sd_table_entry_counter[i] <= sd_table_entry_counter[i];
                        sd_table_id[i][sd_table_entry_counter[i]] <= sd_table_id[i][sd_table_entry_counter[i]];
                        sd_table_src[i][sd_table_entry_counter[i]] <= sd_table_src[i][sd_table_entry_counter[i]];
                        sd_table_dest[i][sd_table_entry_counter[i]] <= sd_table_dest[i][sd_table_entry_counter[i]];
                    end                    
                end
            
            end
        end
    endgenerate

 



endmodule