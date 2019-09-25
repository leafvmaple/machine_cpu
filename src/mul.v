// Multiplier

`ifndef _MUL_V_
`define _MUL_V_

`include "config.v"

module Mul32(prod, a, b);

output reg [63:0] prod;
input [31:0] a, b;

integer i;
always @(a or b) begin
    prod[63:32] = 0;
    prod[31:0] = b;

    for (i = 0; i < 32; i = i + 1) begin
        if (prod[0] & 1'b1)
            prod[63:32] = prod[63:32] + a;
        else
            prod[63:32] = prod[63:32];
        prod = prod >> 1;
    end
end

endmodule

`endif
