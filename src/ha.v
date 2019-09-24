// Half Adder
`ifndef _HA_V_
`define _HA_V_

module HalfAdder(sum, carry, a, b);

output sum, carry;
input a, b;

assign sum = a ^ b;
assign carry = a & b; 

endmodule

`endif