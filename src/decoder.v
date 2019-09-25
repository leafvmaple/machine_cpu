// Instruction Decoder

`include "alu.v"

/*
ALUOp
load word: 00
save word: 00
beq      : 01
R Type   : 10

ALUCtr
AND   4'b0000
OR    4'b0001
ADD   4'b0010
MINUS 4'b0110

MUL   4'b0011
DIV   4'b0100
*/

module ALUDecoder(aluCtr, aluOp, funct);

output reg [3:0] aluCtr;
input [1:0] aluOp;
input [5:0] funct;

always @(aluOp) begin
    case (aluOp)
        2'b00: aluCtr = 4'b0010;
        2'b01: aluCtr = 4'b0110;
        2'b10: begin
            case (funct)
                6'b100000: aluCtr = 4'b0010; // ADD
                6'b100010: aluCtr = 4'b0110; // SUB
                6'b100100: aluCtr = 4'b0000; // ADD
                6'b100101: aluCtr = 4'b0001; // OR
                default: aluCtr = 4'b0000;
            endcase
        end
        default: aluCtr = 4'b0000;
    endcase
end

endmodule

module Decoder(aluOp, rs, rt, rd, funct, inst);

output [5:0] funct;
output [4:0] rs, rt, rd, shamt;
output reg [1:0] aluOp;
input [31:0] inst;

wire [5:0] op;

assign {op, rs, rt, rd, shamt, funct} = inst;

always @(op) begin
    case (op)
        6'b000000: aluOp = 2'b10;
        6'b100011: aluOp = 2'b00;
        6'b101011: aluOp = 2'b00;
        6'b000100: aluOp = 2'b01;
        default: aluOp = 2'b10;
    endcase
end

endmodule