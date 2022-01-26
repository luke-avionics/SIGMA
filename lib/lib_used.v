`timescale 1ns/10ps

`celldefine
module PDDW04DGZ_H_G (I, OEN, REN, PAD, C);
  input I, OEN, REN;
  inout PAD;
  output C;

  wire   MG, pull_pad, pull_c;
  parameter PullTime = 10000;

  bufif0 (PAD_q, I, OEN);
  pmos   (MG, PAD_q, 1'b0);
  bufif1 (weak1, weak0) (PAD_i, 1'b0, pull_pad);
  pmos   (MG, PAD_i, 1'b0);
  pmos   (PAD, MG, 1'b0);
  bufif1 (C_buf, PAD, 1'b1);
  bufif1 (weak0,weak1) (C_buf, 1'b0, pull_c);
  buf    (C, C_buf);
  not    (RE, REN);
  buf    #(PullTime,0) (pull_pad, RE);
  buf    (pull_c, RE);

`ifdef TETRAMAX
`else
  always @(PAD) begin
    if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") && $countdrivers(PAD))
      $display("%t ++BUS CONFLICT++ : %m", $realtime);
  end

  specify
    (I => PAD)=(0, 0);
    (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => C)=(0, 0);
  endspecify
`endif
endmodule
`endcelldefine

`celldefine
module PVDD2ANA_H_G (AVDD);
  inout AVDD;
  tran (AVDD, AVDD);
endmodule
`endcelldefine


`celldefine
module LVLHLD1BWP30P140 (I, Z);
    input I;
    output Z;
    buf (Z, I);

  specify
    (I => Z) = (0, 0);
  endspecify
endmodule
`endcelldefine

`celldefine
module LVLHLD2BWP30P140 (I, Z);
    input I;
    output Z;
    buf (Z, I);

  specify
    (I => Z) = (0, 0);
  endspecify
endmodule
`endcelldefine

`celldefine
module LVLHLD4BWP30P140 (I, Z);
    input I;
    output Z;
    buf (Z, I);

  specify
    (I => Z) = (0, 0);
  endspecify
endmodule
`endcelldefine

`celldefine
module LVLHLD8BWP30P140 (I, Z);
    input I;
    output Z;
    buf (Z, I);

  specify
    (I => Z) = (0, 0);
  endspecify
endmodule
`endcelldefine

`celldefine
module LVLLHD1BWP30P140 (I, Z);
    input I;
    output Z;
    buf (Z, I);

  specify
    (I => Z) = (0, 0);
  endspecify
endmodule
`endcelldefine

`celldefine
module LVLLHD2BWP30P140 (I, Z);
    input I;
    output Z;
    buf (Z, I);

  specify
    (I => Z) = (0, 0);
  endspecify
endmodule
`endcelldefine

`celldefine
module LVLLHD4BWP30P140 (I, Z);
    input I;
    output Z;
    buf (Z, I);

  specify
    (I => Z) = (0, 0);
  endspecify
endmodule
`endcelldefine

`celldefine
module LVLLHD8BWP30P140 (I, Z);
    input I;
    output Z;
    buf (Z, I);

  specify
    (I => Z) = (0, 0);
  endspecify
endmodule
`endcelldefine

`celldefine
module TIEHBWP30P140 (Z);
    output Z;
    buf (Z, 1'b1);

endmodule
`endcelldefine

`celldefine
module TIELBWP30P140 (ZN);
    output ZN;
    buf (ZN, 1'b0);

endmodule
`endcelldefine

