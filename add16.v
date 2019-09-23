// 16 bit Adder

`ifndef _ADD16_V_
`define _ADD16_V_ 

`include "cla4.v"

module Add16(out, a, b);

output [15:0] out;
input [15:0] a, b;

wire c4, c8, c12, c16;

CLA4 cla0(out[3:0],   c4,  a[3:0],   b[3:0],   1'b0);
CLA4 cla1(out[7:4],   c8,  a[7:4],   b[7:4],   c4);
CLA4 cla2(out[11:8],  c12, a[11:8],  b[11:8],  c8);
CLA4 cla3(out[15:12], c16, a[15:12], b[15:12], c12);

endmodule

`endif