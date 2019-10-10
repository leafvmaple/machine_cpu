`ifndef _ALU_V_
`define _ALU_V_

`include "const.v"
`include "add.v"

`define AND   4'b0000
`define OR    4'b0001
`define ADD   4'b0010
`define MINUS 4'b0110

`define MUL   4'b0011
`define DIV   4'b0100

module ALU(out, zf, aluCtr, A, B);

output reg [31:0] out;
output reg zf;
input [31:0] A, B;
input [3:0] aluCtr;

always @(aluCtr, A, B) begin
    case (aluCtr)
    `ifdef _CUSTOM_GATE
        `ADD: Add32(out, carry, A, B, 1'b0)
    `else
        `ADD:   out = A + B;
        `MINUS: out = A - B;
        `MUL:   out = A * B;
        `DIV:   out = A / B;
        `AND:   out = A & B;
        `OR:    out = A | B;
    `endif
        default: out = 0;
    endcase
    if (out == 0) zf = 1;
    else zf = 0;
    $display($time, " [ALU] aluCtr = %b zf = %b A = %d B = %d ", aluCtr, zf, A, B);
end

endmodule

`endif