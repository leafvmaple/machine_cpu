// Half Adder
`ifndef _HA_V_
`define _HA_V_

module HalfAdder(sum, carry, a, b);

output sum, carry;
input a, b;

`ifdef CUSTOM_GATE
    xor(sum, a, b);
    and(carry, a, b);
`else
    assign sum = a ^ b;
    assign carry = a & b; 
`endif

endmodule

`endif