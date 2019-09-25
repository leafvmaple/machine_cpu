// Divider

`ifndef _DIV_V_
`define _DIV_V_

module Div32(cons, a, b);

output reg [63:0] cons;
input [63:0] a;
input [31:0] b;

integer i;
always @(a or b) begin
    cons = a;

    for (i = 0; i < 33; i = i + 1) begin
        cons[63:32] = cons[63:32] - b;
        if (cons[63] & 1'b1) begin
            cons[63:32] = cons[63:32] + b;
            cons = cons << 1;
        end
        else begin
            cons = cons << 1;
            cons[0] = 1;
        end
    end
    cons[63:32] = cons[63:32] >> 1;
end

endmodule

`endif