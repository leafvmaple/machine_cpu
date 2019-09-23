// Carry Look-ahead Adder
`include "ha.v"

module CLA4(out, a, b);

output [3:0] out;
input [3:0] a, b;

wire [3:0] carry;

HalfAdder HalfAdder_Gate(out[0], carry[0], a[0], b[0]);
FullAdder FullAdder_Gate0(out[1], carry[1], a[1], b[1], carry[0]);
FullAdder FullAdder_Gate1(out[2], carry[2], a[2], b[2], carry[1]);
FullAdder FullAdder_Gate2(out[3], carry[3], a[3], b[3], carry[2]);
FullAdder FullAdder_Gate3(out[4], carry[4], a[4], b[4], carry[3]);

endmodule