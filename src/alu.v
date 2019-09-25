`ifndef _ALU_V_
`define _ALU_V_

`include "const.v"
`include "add.v"

`define PLUS  5'b00000
`define MINUS 5'b00001
`define MUL   5'b00010
`define DIV   5'b00011
`define AND   5'b00100
`define OR    5'B00101

module ALU(out, func, A, B);

output reg [31:0] out;
input [31:0] A, B;
input [5:0] func;

always @(func, A, B) begin
    case (func)
    `ifdef _CUSTOM_GATE
        `PLUS: Add32(out, carry, A, B, 1'b0)
    `else
        `PLUS:  out = A + B;
        `MINUS: out = A - B;
        `MUL:   out = A * B;
        `DIV:   out = A / B;
        `AND:   out = A & B;
        `OR:    out = A | B;
    `endif
        default: out = 0;
    endcase
end

endmodule

`endif