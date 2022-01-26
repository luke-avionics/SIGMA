//**********************************************************************
// Copyright 2015 by Silicon Creations Inc.  All rights reserved.      *
// No portion of this material may be reproduced in any form           *
// without the written permission from Silicon Creations.              *
// All information contained is Silicon Creations company private,     *
// proprietary, and trade secret.                                      *
//**********************************************************************
// Context:     		Silicon Creations Verification IP
// Filename:    		test_LVDSTS28HPCPBI1B.v
// Author:      		J.Lumish
// Version 			1.3:	Thu Jul  9 17:14:53 EDT 2015
// 						Added logic to toggle resets/powerdowns at the end of a test
// 				1.2:	Wed Jun 24 10:53:42 EDT 2015
// 						changed sync_en to sync_en
// 				1.1:	Mon May  4 13:24:54 EDT 2015
//						Updated RX Checks + Added more detail on checking
//				1.0: 	Mon Mar  2 18:30:01 EST 2015
// support@siliconcr.com
//**********************************************************************
//
// LVDS BDIR Testbench
//

`include "defines.h"
`timescale 1 ps / 1 fs
`define TSTEP  1e-12
// tests to run
`define REF_PERIOD_1000MHZ 1000
`define TEST_TRANSMIT 0
`define TEST_RECEIVE 1

// Controls
`define DDR_EN 0
`define INV_CP 0
`define SYNC_EN 0


module test_LVDSTS28HPCPBI1B();

wire PAD_P_h; 
wire PAD_N_h;
wire PAD_P_v; 
wire PAD_N_v;
reg reset_prbs;
wire parclk;
wire [1:0] prbsdata_parallel; 
reg ddr_en;
reg txen;
reg rxen;
wire [1:0] txda; 
wire [1:0] rxda_s_h;
wire [1:0] rxda_s_v;

reg cp;
always begin
	#(`REF_PERIOD_1000MHZ / 2.0) cp = ~cp; 
end

wire prbsdata_serial_sdr;
wire prbsdata_serial_ddr;
wire prbsdata_serial;
assign prbsdata_serial = ddr_en ? prbsdata_serial_ddr : prbsdata_serial_sdr;
assign PAD_P_h = txen ? 1'bz : rxen ? prbsdata_serial : 1'bz;
assign PAD_N_h = txen ? 1'bz : rxen ? ~prbsdata_serial : 1'bz;
assign PAD_P_v = txen ? 1'bz : rxen ? prbsdata_serial : 1'bz;
assign PAD_N_v = txen ? 1'bz : rxen ? ~prbsdata_serial : 1'bz;

prbsgen_serial_sdr #(.poly1(1), .poly2(2)) Xprbsgen_serial_sdr (.clk(cp), .out(prbsdata_serial_sdr), .insert_error(1'b0));
prbsgen_serial_ddr #(.poly1(1), .poly2(2)) Xprbsgen_serial_ddr (.clk(cp), .out(prbsdata_serial_ddr), .insert_error(1'b0));

prbscheck_serial_sdr #(.poly1(1), .poly2(2)) Xprbscheck_serial_sdr_for_rx_h (.in(rxda_s_h[0]), .clk(cp), .error(prbscheck_serial_error_sdr_for_rx_h));
prbscheck_serial_sdr #(.poly1(1), .poly2(2)) Xprbscheck_serial_sdr_for_rx_v (.in(rxda_s_v[0]), .clk(cp), .error(prbscheck_serial_error_sdr_for_rx_v));

prbscheck_serial_sdr #(.poly1(1), .poly2(2)) Xprbscheck_serial_sdr_h (.in(PAD_P_h), .clk(cp), .error(prbscheck_serial_error_sdr_h));
prbscheck_serial_ddr #(.poly1(1), .poly2(2)) Xprbscheck_serial_ddr_h (.in(PAD_P_h), .clk(cp), .error(prbscheck_serial_error_ddr_h));
prbscheck_serial_sdr #(.poly1(1), .poly2(2)) Xprbscheck_serial_sdr_v (.in(PAD_P_v), .clk(cp), .error(prbscheck_serial_error_sdr_v));
prbscheck_serial_ddr #(.poly1(1), .poly2(2)) Xprbscheck_serial_ddr_v (.in(PAD_P_v), .clk(cp), .error(prbscheck_serial_error_ddr_v));


prbsgen_parallel_lsbfirst_tb #(.nbits(2), .poly1(1), .poly2(2)) Xprbsgen_parallel_lsbfirst (
	.clk(cp),
	.resetn(~reset_prbs),
	.clear(1'b0),
	.out(txda)
	);

prbscheck_parallel_lsbfirst_tb #(.nbits(2), .poly1(1), .poly2(2)) Xprbscheck_parallel_lsbfirst_h (.in(rxda_s_h), .clk(cp), .error(prbscheck_parallel_error_h), .resetn(~reset_prbs));
prbscheck_parallel_lsbfirst_tb #(.nbits(2), .poly1(1), .poly2(2)) Xprbscheck_parallel_lsbfirst_v (.in(rxda_s_v), .clk(cp), .error(prbscheck_parallel_error_v), .resetn(~reset_prbs));

// Check that PAD_P_v=txda[0] for SDR mode
reg serial_data_error_sdr_v; 
always @(posedge cp) begin
	if (PAD_P_v==txda[0]) begin
		serial_data_error_sdr_v <= 1'b0;
	end
	else begin
		serial_data_error_sdr_v <= 1'b1; 
	end
end

// Check that PAD_P_h=txda[0] for SDR mode
reg serial_data_error_sdr_h; 
always @(posedge cp) begin
	if (PAD_P_h==txda[0]) begin
		serial_data_error_sdr_h <= 1'b0;
	end
	else begin
		serial_data_error_sdr_h <= 1'b1; 
	end
end


// instantiate module LVDSTS28HPCPBI1B
// Module instantiated with  /working/bin/make_verilog_bench.pl 
reg reset_n;
reg sync_en;
reg vbias_sel;
reg vbias_in;
reg [3:0] txdrv;
reg inv_cp;
reg rterm_en;
reg [2:0] rterm_val;
reg rxcm_en;
reg bias_en;
reg tx_cm;
wire rxda;
LVDSTS28HPCPBI1B_V XLVDSTS28HPCPBI1B_V (
	.PAD_N(PAD_N_v),
	.PAD_P(PAD_P_v),
	.VDDIO(1'b1),
	.VDD(1'b1),
	.VSS(1'b0),
	.VSSS(1'b0),
	.SYNC_EN(sync_en),
	.BIAS_EN(bias_en),
	.CP(cp),
	.DDR_EN(ddr_en),
	.INV_CP(inv_cp),
	.RESET_N(reset_n),
	.RTERM_EN(rterm_en),
	.RTERM_VAL(rterm_val),
	.RXCM_EN(rxcm_en),
	.RXDA(rxda_v),
	.RXDA_S(rxda_s_v),
	.TX_CM(tx_cm), 
	.RXEN(rxen),
	.TXDA(txda),
	.TXDRV(txdrv),
	.TXEN(txen),
	.VBIAS_IN(vbias_in),
	.VBIAS_SEL(vbias_sel)
	);

LVDSTS28HPCPBI1B_H XLVDSTS28HPCPBI1B_H (
	.PAD_N(PAD_N_h),
	.PAD_P(PAD_P_h),
	.VDDIO(1'b1),
	.VDD(1'b1),
	.VSS(1'b0),
	.VSSS(1'b0),
	.PAD_N(PAD_N_h),	// diff input clk <------- input
	.PAD_P(PAD_P_h),    // diff input clk <-------
	.RESET_N(1'b0),		// no clear description, is this set right ???
	.VBIAS_SEL(1'b0),	// for transmitter
	.VBIAS_IN(1'b0),	// for transmitter
	.TXDRV(4'b1000),	// for transmitter
	.DDR_EN(1'b0),		// no ddr
	.TXEN(1'b0),		// for transmitter
	.TXDA(2'b00),	   	// for transmitter
	.CP(1'b0),			// no clock signal
	.INV_CP(1'b0),		// no clock signal
	.RXEN(1'b1),		// receiver enable
	.RTERM_EN(rterm_en),// for termination <------- input
	.RTERM_VAL(rterm_val),// for termination <------- input
	.RXCM_EN(1'b0),		// RX common mode generation internally, is this set right ???
	.BIAS_EN(1'b1),		// bias circuit enable
	.RXDA(rxda_h),      // used clk for chip -------> output
	.RXDA_S(),  		// no parallel
	.TX_CM(tx_cm)		// LVDS mode, sub-LVDS mode <------- input, we need to modify it, is this set right ???
	);


initial begin
	reset_prbs 		= 1'b1; 
	// Enables
	bias_en			= 1'b0;
	reset_n			= 1'b0;
	rxen			= 1'b0; 
	txen			= 1'b0; 
	vbias_in		= 1'b0;
	
	// Fixed Controls
	rterm_val		= 4'b1000;
	rxcm_en			= 1'b0; 
	txdrv			= 4'b1000; 
	vbias_sel		= 1'b0; 

	// Other Controls
	sync_en			= 1'b0; 
	cp			= 1'b0;
	ddr_en			= 1'b0;
	inv_cp			= 1'b0;
	rterm_en		= 1'b1;
	tx_cm			= 1'b0; 

	#1e6;
	bias_en			= 1'b1;
	vbias_in		= 1'b1;
	#1e6; 
	reset_n			= 1'b1; 
	#1e6; 

	reset_prbs 		= 1'b0; 

/////////////////////////////////////////
	ddr_en			= `DDR_EN;
	inv_cp			= `INV_CP; 
	sync_en			= `SYNC_EN; 
/////////////////////////////////////////

// In Transmit Mode:
// If ddr_en=1'b1, check prbscheck_serial_error
// If ddr_en=1'b0, check serial_data_error_sdr
// If sync_en=1'b1, check serial_data_error_sdr
// If inv_cp=1'b1, check test_lvds.XLVDSTS28HPCPBI1B.Xlvds_top.clk1 timing with respect to data (should be on falling edge) 

// In Receive Mode:
// If ddr_en=1'b1, check prbscheck_parallel_error 
// If ddr_en=1'b0, visual inspection to verify that every other bit is clocked out on rxda_s[0] is required
// If inv_cp=1'b1, check timing of output data/clock compared to input data, its easier to follow in sdr mode since only 1 edge is used

	if (`TEST_TRANSMIT) begin
		$display("Testing Transmit Mode, ddr_en=%d, inv_cp=%d, sync_en=%d",ddr_en,inv_cp,sync_en); 
		casex ({sync_en,ddr_en}) 
			2'b00 : $display("Retime din<0> and send to driver --> check serial SDR PRBS Errors");
			2'b01 : $display("Perform 2->1 DDR serialization on din<1:0> and send to driver --> check serial DDR PRBS Errors");
			2'b1x : $display("Send din<0> asynchronously to driver --> check serial SDR PRBS Errors");
		endcase
		txen		= 1'b1; // enable transmitter
		rxen		= 1'b0; // disable receiver
		#1e6; 
	end
	if (`TEST_RECEIVE) begin
		$display("Testing Receive Mode, ddr_en=%d, inv_cp=%d",ddr_en,inv_cp); 
		case (ddr_en) 
			1'b0 : $display("Perform SDR De-serialization --> Check serial prbs checkers for RX data");
			1'b1 : $display("Perform DDR De-serialization --> check parallel PRBS checker"); 
		endcase
		rxen		= 1'b1; // enable receiver 
		txen		= 1'b0; // disable transmitter
		#1e6; 
	end
	$display ("Check Powerup/Powerdown:");
	$display ("	Disable Bias");
	#1e6; 
	bias_en				= 1'b0;
	#1e6; 
	bias_en				= 1'b1;

	if (`TEST_TRANSMIT) begin
		$display ("	Disable TX");
		#1e6; 
		txen				= 1'b0;
		#1e6; 
		txen				= 1'b1;
	end
	if (`TEST_RECEIVE) begin
		$display ("	Disable RX");
		#1e6; 
		rxen				= 1'b0;
		#1e6; 
		rxen				= 1'b1;
	end
	$display ("	Disable Reset");
	#1e6; 
	reset_n				= 1'b0;
	#1e6; 
	reset_n				= 1'b1;
	#1e6; 

	$display("Done");
	$finish; 

end


initial
  	begin
        $fsdbDumpfile("test.rtl.fsdb");
        $fsdbDumpvars;
end




endmodule
