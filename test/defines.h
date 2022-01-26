//16 bit version of defines.v
// 

// Supply and Reference Voltage Values
`define VDDHVVAL 1.8
`define VDDLVVAL 1.00
`define VSSVAL 0
`define VDDHVBIN `VOLTTOBIN(`VDDHVAL) 
`define VDDLVBIN `VOLTTOBIN(`VDDLVAL) 
`define VSSBIN `VOLTTOBIN(`VSSVAL) 

// Analog Tolerance
`define QPMISMATCH 0.005
`define QPMISMATCH1 0.005
//`define QPMISMATCH 0
`define VCODACMISMATCH 0.001  

// worst case 60 / 30 ps 
`define INV_DELAY	15
`define INV_DELAY_LVT	15

// VT Values
`define VTN 0.25
`define VTP 0.25
`define VTNH 0.4
`define VTPH 0.4

// These define bus sizes for the 'analog' signals
`define BUSSIZE 16
`define BUSWIDTH [`BUSSIZE-1:0]
`define BUSSIZE2X  2*`BUSSIZE
`define BUSWIDTH2X [`BUSSIZE2X-1:0]
`define BUSSIZE3X  3*`BUSSIZE
`define BUSWIDTH3X [`BUSSIZE3X-1:0]

// Begin DECODER RING 
`define DRSIZE		`BUSSIZE	
`define DRWIDTH		[`BUSSIZE-1:0] 

// Handy macro to convert voltages to binary representation
`define MAXV       3.0
`define FULLSCALE 32767 
`define FULLSCALE_REAL 32767.0
`define FULLSCALE2X 2147483647 
`define FULLSCALE_REAL2X 2147483647.0

// Voltage conversion functions
`define VOLTTOBIN(value)  ((value) / `MAXV) * `FULLSCALE
`define VOLTTOBIN2X(value)  ((value) / `MAXV) * `FULLSCALE2X
`define BINTOVOLT(value)  ( $itor($signed(value)) / `FULLSCALE_REAL  )  * `MAXV
`define BINTOVOLT2X(value)  ( $itor($signed(value)) / `FULLSCALE_REAL2X  )  * `MAXV


`define MAXI       3.0e-3
// Current conversion functions
`define CURRENTTOBIN(value)  ((value) / `MAXI) * `FULLSCALE
`define BINTOCURRENT(value)  ( $itor($signed(value)) / `FULLSCALE_REAL) * `MAXI 

// Random Seed Value
`define SEED 1	

// Bias Currents
`define IBG		`DRSIZE'h10ff	
`define IBG16u		`DRSIZE'h11ff	
`define IBG32u		`DRSIZE'h12ff	
`define IPTAT8u		`DRSIZE'h13ff	
`define IPTAT16u	`DRSIZE'h14ff	
`define IQPBBM		`DRSIZE'h15ff	

// bias voltages
`define VBG		`DRSIZE'h20ff	
`define VCSN		`DRSIZE'h21ff	
`define VCASN		`DRSIZE'h22ff	
`define VCSP		`DRSIZE'h23ff	
`define VCASP		`DRSIZE'h24ff	

// hard ties
//`define CDL_HARDTIE_VDD 1'b1
`define CDL_HARDTIE_vfollow 1'b1
`define CDL_HARDTIE_itestvco 1'b1
`define CDL_HARDTIE_ibias_bbm 1'b1
