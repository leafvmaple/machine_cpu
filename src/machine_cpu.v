// 16 bit Adder

`ifndef _CPU_V_
`define _CPU_V_ 

`include "add.v"
`include "mul.v"

module Adder(OUT, A, B);

input [31:0] A, B;
output [31:0] OUT;
wire carry;

Add32 add(OUT, carry, A, B, 1'b0);

endmodule

module Multiplier(OUT, A, B);

input [31:0] A, B;
output [63:0] OUT;

Mul32 mul(OUT, A, B);

endmodule

`endif