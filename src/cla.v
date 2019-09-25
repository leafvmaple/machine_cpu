// 4bit Carry Look-ahead Adder
`ifndef _CLA_V_
`define _CLA_V_

`include "ha.v"
`include "fa.v"

module CLABase4(c, g, p, c0);

output [3:0] c;
input [3:0] g, p;
input c0;

assign c[0] = g[0] | p[0] & c0;
assign c[1] = g[1] | p[1] & g[0] | p[1] & p[0] & c0;
assign c[2] = g[2] | p[2] & g[1] | p[2] & p[1] & g[0] | p[2] & p[1] & p[0] & c0;
assign c[3] = g[3] | p[3] & g[2] | p[3] & p[2] & g[1] | p[3] & p[2] & p[1] & g[0] | p[3] & p[2] & p[1] & p[0] & c0; // 3 Gate Delay

endmodule

module CLA4(sum, c4, a, b, c0);

output [3:0] sum;
output c4;
input [3:0] a, b;
input c0;

wire [3:0] g, p, c;

assign g = a & b;
assign p = a | b;

CLABase4 clabase(c, g, p, c0);

assign sum[0] = a[0] ^ b[0] ^ c0;
assign sum[1] = a[1] ^ b[1] ^ c[0];
assign sum[2] = a[2] ^ b[2] ^ c[1];
assign sum[3] = a[3] ^ b[3] ^ c[2]; // 4 Gate Delay
assign c4 = c[3];

endmodule

module BCLA4(sum, bg, bp, a, b, c0);

output [3:0] sum;
output bg, bp;
input [3:0] a, b;
input c0;

wire [3:0] g, p, c;

assign g = a & b;
assign p = a | b;

CLABase4 clabase(c, g, p, c0);

assign bg = g[3] | p[3] & g[2] | p[3] & p[2] & g[1] | p[3] & p[2] & p[1] & g[0];
assign bp = p[3] & p[2] & p[1] & p[0];

assign sum[0] = a[0] ^ b[0] ^ c0;
assign sum[1] = a[1] ^ b[1] ^ c[0];
assign sum[2] = a[2] ^ b[2] ^ c[1];
assign sum[3] = a[3] ^ b[3] ^ c[2]; // 4 Gate Delay

endmodule

`endif