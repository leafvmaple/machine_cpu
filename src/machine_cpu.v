// 16 bit Adder

`ifndef _CPU_V_
`define _CPU_V_ 

`define _BLCA // use BCLA

`include "add.v"

module CPU(OUT, A, B);

input [31:0] A, B;
output [31:0] OUT;
wire carry;

Add32 add(OUT, carry, A, B, 1'b0);

endmodule

`endif