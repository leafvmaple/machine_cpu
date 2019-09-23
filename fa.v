// Full Adder
`ifndef _FA_V_
`define _FA_V_ 

`include "ha.v"

module FullAdder(sum, carry, a, b, c);

output sum, carry;
input a, b, c;

wire inetsum, carry1, carry2;

HalfAdder ha1(inetsum, carry1, a, b);
HalfAdder ha2(sum, carry2, c, inetsum);

`ifdef CUSTOM_GATE
    or(carry, carry1, carry2);
`else
    assign carry = carry1 | carry2;
`endif

endmodule

`endif