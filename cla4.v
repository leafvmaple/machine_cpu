// 4bit Carry Look-ahead Adder
`ifndef _CLA4_V_
`define _CLA4_V_

`include "ha.v"
`include "fa.v"

module CLA4(sum, c4, a, b, c0);

output [3:0] sum;
output c4;
input [3:0] a, b;
input c0;

wire [3:0] g, p;
wire c1, c2, c3;

assign g = a & b;
assign p = a | b;

assign sum[0] = a[0] ^ b[0];
assign c1 = g[0] | p[0] & c0;

assign sum[1] = a[1] ^ b[1] ^ c1;
assign c2 = g[1] | p[1] & g[0] | p[1] & p[0] & c0;

assign sum[2] = a[2] ^ b[2] ^ c2;
assign c3 = g[2] | p[2] & g[1] | p[2] & p[1] & g[0] | p[2] & p[1] & p[0] & c0;

assign sum[3] = a[3] ^ b[3] ^ c2; // 4 Gate Delay
assign c4 = g[3] | p[3] & g[2] | p[3] & p[2] & g[1] | p[3] & p[2] & p[1] & g[0] | p[3] & p[2] & p[1] & p[0] & c0; // 3 Gate Delay

endmodule

`endif