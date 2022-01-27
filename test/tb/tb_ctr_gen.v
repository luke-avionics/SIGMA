`include "defines.h"
`timescale 1ns / 1ps


module tb_ctr_gen ();
	parameter I_ROW_SIZE = 4;
	parameter I_COL_SIZE = 8;
    parameter W_ROW_SIZE = 8;
    parameter W_COL_SIZE = 4;
    parameter LOG2_W_ROW_SIZE = 3;
    parameter LOG2_W_COL_SIZE = 2;
    parameter LOG2_I_ROW_SIZE = 2;
    parameter LOG2_I_COL_SIZE = 3;
    parameter I_BUFF_SIZE = 32;
    parameter W_BUFF_SIZE = 32;
	parameter DATA_TYPE =  32 ;
	parameter NUM_PES =  32 ;
    parameter LOG2_PES =  5 ;
    parameter LOG2_W_BUFF_SIZE =  5;
    parameter NUM_TESTS = 1;


	reg clk = 0;
	reg rst;

    reg i_valid=1;
    reg i_bit_map[I_ROW_SIZE-1:0][I_COL_SIZE-1:0];
    reg [DATA_TYPE-1:0]i_nonzero_ele[I_BUFF_SIZE-1:0];

    reg w_valid=0;
    reg w_bit_map[W_ROW_SIZE-1:0][W_COL_SIZE-1:0];

    reg [DATA_TYPE-1:0]w_nonzero_ele[W_BUFF_SIZE-1:0];

    reg done_computing_one_tile = 1;


    initial begin
        i_bit_map[3][7:0]={1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0};  
        i_bit_map[2][7:0]={1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};  
        i_bit_map[1][7:0]={1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};  
        i_bit_map[0][7:0]={1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0};  

        i_nonzero_ele[31:0]={32'hABCD_1234, 32'h5678_ABCD, 32'hFFFF_1234, 32'h0000_1234,
                            32'hABCD_0000, 32'hABCD_1234, 32'h1111_1234, 32'h3333_1234,
                            32'h6666_7777, 32'h789A_0000, 32'hABCD_1234, 32'h0000_0000,
                            32'h0000_0000, 32'h0000_0000, 32'h0000_0000, 32'h0000_0000,
                            32'h0000_0000, 32'h0000_0000, 32'h0000_0000, 32'h0000_0000,
                            32'h0000_0000, 32'h0000_0000, 32'h0000_0000, 32'h0000_0000,
                            32'h0000_0000, 32'h0000_0000, 32'h0000_0000, 32'h0000_0000,
                            32'h0000_0000, 32'h0000_0000, 32'h0000_0000, 32'h0000_0000};        
        w_bit_map[7][3:0]={1'b1, 1'b1, 1'b1, 1'b0};
		w_bit_map[6][3:0]={1'b0, 1'b0, 1'b1, 1'b0}; 
		w_bit_map[5][3:0]={1'b1, 1'b1, 1'b0, 1'b0};
		w_bit_map[4][3:0]={1'b0, 1'b0, 1'b1, 1'b0}; 
        w_bit_map[3][3:0]={1'b1, 1'b0, 1'b1, 1'b0};  
        w_bit_map[2][3:0]={1'b1, 1'b0, 1'b1, 1'b0};  
        w_bit_map[1][3:0]={1'b1, 1'b1, 1'b1, 1'b0};  
        w_bit_map[0][3:0]={1'b0, 1'b1, 1'b1, 1'b0};  

        w_nonzero_ele[31:0]={32'hABCD_1234, 32'h5678_ABCD, 32'hFFFF_1234, 32'h0000_1234,
                            32'hABCD_0000, 32'hABCD_1234, 32'h1111_1234, 32'h3333_1234,
                            32'h6666_7777, 32'h789A_0000, 32'hABCD_1234, 32'hABCD_1234,
                            32'hABCD_1234, 32'hFFFF_CCCC, 32'h0000_AAAA, 32'h0000_0000,
                            32'h0000_0000, 32'h0000_0000, 32'h0000_0000, 32'h0000_0000,
                            32'h0000_0000, 32'h0000_0000, 32'h0000_0000, 32'h0000_0000,
                            32'h0000_0000, 32'h0000_0000, 32'h0000_0000, 32'h0000_0000,
                            32'h0000_0000, 32'h0000_0000, 32'h0000_0000, 32'h0000_0000}; 
    end



    reg r_i_valid;
    reg r_i_bit_map[I_ROW_SIZE-1:0][I_COL_SIZE-1:0];
    reg [DATA_TYPE-1:0]r_i_nonzero_ele[I_BUFF_SIZE-1:0];
    reg r_w_valid;
    reg r_w_bit_map[W_ROW_SIZE-1:0][W_COL_SIZE-1:0];
    reg [DATA_TYPE-1:0]r_w_nonzero_ele[W_BUFF_SIZE-1:0];
    reg r_done_computing_one_tile;


    reg [DATA_TYPE-1:0]stationary_buffer[NUM_PES-1:0];
    reg output_bit_map[W_ROW_SIZE-1:0][I_COL_SIZE-1:0];

	// generate simulation clock
	always #1 clk = !clk;



	// set reset signal
	initial begin
		rst = 1'b1;
		#4
		rst = 1'b0;
	end

	reg [10:0] counter = 'd0;

	// generate input signals to DUT
	always @ (posedge clk) begin
		r_i_valid = i_valid;
		r_i_bit_map = i_bit_map;
		r_i_nonzero_ele = i_nonzero_ele;
		r_w_valid = w_valid;
		r_w_bit_map = w_bit_map;
		r_w_nonzero_ele = w_nonzero_ele;
		r_done_computing_one_tile = done_computing_one_tile;
	end


	// instantiate system (DUT)
	ctr_gen # (
		.I_ROW_SIZE(I_ROW_SIZE),
		.I_COL_SIZE(I_COL_SIZE),
		.I_BUFF_SIZE(I_BUFF_SIZE),
		.W_ROW_SIZE(W_ROW_SIZE),
		.W_COL_SIZE(W_COL_SIZE),
		.W_BUFF_SIZE(W_BUFF_SIZE),
		.DATA_TYPE(DATA_TYPE),
		.LOG2_W_ROW_SIZE(LOG2_W_ROW_SIZE),
		.LOG2_W_COL_SIZE(LOG2_W_COL_SIZE),
		.LOG2_I_ROW_SIZE(LOG2_I_ROW_SIZE),
		.LOG2_I_COL_SIZE(LOG2_I_COL_SIZE),
		.LOG2_W_BUFF_SIZE(LOG2_W_BUFF_SIZE),
		.NUM_PES(NUM_PES),
		.LOG2_PES(LOG2_PES)
        )
		my_ctr_gen (
		.clk(clk),
		.rst(rst),
		.i_valid(r_i_valid),
		.i_bit_map(r_i_bit_map),
		.i_nonzero_ele(r_i_nonzero_ele),
		.w_valid(r_w_valid),
		.w_bit_map(r_w_bit_map),
		.w_nonzero_ele(r_w_nonzero_ele),
		.done_computing_one_tile(r_done_computing_one_tile),
		.stationary_buffer(stationary_buffer),
		.output_bit_map(output_bit_map)
		);


	// // create simulation waveform
	// initial begin
	// 	$vcdplusfile("flexdpe.vpd");
	//  	$vcdpluson(0, tb_flexdpe); 
	// 	#100 $finish;
	// end


	//================================================================
	// save simulation file
	//================================================================

	//========== VPD ============
	`ifdef VPD
	initial
	begin
			$vcdplusfile("tb_flexdpe.vpd");
			$vcdpluson;
	end
	`endif

	//========== VCD ============
	`ifdef VCD
	initial
	begin
			$dumpfile("tb_flexdpe.vcd");
			$dumpvars;
	end
	`endif

	//========== RTLVCD ============
	`ifdef RTLVCD
	initial
	begin
			$dumpfile("tb_flexdpe.rtl.vcd");
			$dumpvars;
			#100 $finish;
	end
	`endif

	//========== FSDB ============
	`ifdef FSDB
	initial
	begin
			$fsdbDumpfile("tb_flexdpe.fsdb");
			$fsdbDumpMDA();
			$fsdbDumpvars;
			#100 $finish;	
	end
	`endif

	//========== RTLFSDB ==========
	`ifdef RTLFSDB
	initial
	begin
			$fsdbDumpfile("tb_flexdpe.rtl.fsdb");
			$fsdbDumpvars;
	end
	`endif

	//========== SAIF ============
	`ifdef SAIF
	initial
	begin
			$read_lib_saif ("../annotate/SmartExchange_HPCA_28nm_base_tt_1p00v_85c.saif");
			$set_toggle_region (mac_dw_inst);
			$toggle_start;
			# 100
			$toggle_stop;
			$toggle_report("tb_whole_sparse_layer1_image0_pal.saif", 1.0e-9,"tb_whole_sparse_layer1_image0_pal.top_inst");
	end
	`endif


	//========== SDF ============
	`ifdef SDF
	initial
	begin
			$sdf_annotate
			("/home/zy34/SmartExchange_HPCA2020/syn_mac_dw/netlist/mac_dw.sdf",
			mac_dw_inst);
	end
	`endif


endmodule
