// 4bit Ripple Carry Adder
`ifndef _RCA4_V_
`define _RCA4_V_ 

`include "fa.v"
`include "ha.v"

module RCA4(sum, carry, a, b, c0);

output [3:0] sum;
output carry;
input [3:0] a, b;
input c0;

wire [3:0] c;

FullAdder fa0(sum[0], c[0],  a[0], b[0], c0);
FullAdder fa1(sum[1], c[1],  a[1], b[1], c[0]);
FullAdder fa2(sum[2], c[2],  a[2], b[2], c[1]);
FullAdder fa3(sum[3], carry, a[3], b[3], c[2]);

endmodule

`endif