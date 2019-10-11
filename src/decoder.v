// Instruction Decoder

`include "alu.v"

/*
ALUOp
load word       00
save word       00
beq             01
R Type          10
*OR inmmediate  11

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
        2'b00:  aluCtr = 4'b0010;
        2'b01:  aluCtr = 4'b0110;
        2'b10: begin
            case (funct)
                6'b100000: aluCtr = 4'b0010; // ADD
                6'b100010: aluCtr = 4'b0110; // SUB
                6'b100100: aluCtr = 4'b0000; // AND
                6'b100101: aluCtr = 4'b0001; // OR
                default: aluCtr = 4'b0000;
            endcase
        end
        2'b11:   aluCtr = 4'b0001; // OR
        default: aluCtr = 4'b0000;
    endcase
end

endmodule

module Decoder(alu_ctr_sig, reg_dst_sig, reg_wrt_sig, mem_read_sig, mem_wrt_sig, mem_reg_sig, alu_src_sig, branch_sig, jump_sig, rs, rt, rd, inst);

output [4:0] rs, rt, rd;
output [3:0] alu_ctr_sig;
output reg reg_dst_sig, reg_wrt_sig, mem_read_sig, mem_wrt_sig, mem_reg_sig, alu_src_sig, branch_sig, jump_sig;
input [31:0] inst;

reg [1:0] alu_op_sig;
wire [5:0] op, funct;
wire [4:0] shamt;

initial begin
    reg_dst_sig  = 0;
    reg_wrt_sig  = 0;
    mem_read_sig = 0;
    mem_wrt_sig  = 0;
    mem_reg_sig  = 0;
    alu_src_sig  = 0;
    branch_sig   = 0;
end

assign {op, rs, rt, rd, shamt, funct} = inst;

always @(op) begin
    $display($time, " [Decoder] Opcode = %b ", op);
    reg_dst_sig  = 0;
    reg_wrt_sig  = 0;
    mem_read_sig = 0;
    mem_wrt_sig  = 0;
    mem_reg_sig  = 0;
    alu_src_sig  = 0;
    branch_sig   = 0;
    jump_sig     = 0;
    case (op)
        6'b000000: begin 
            alu_op_sig  = 2'b10;       // R Instruction
            reg_wrt_sig = 1;
            reg_dst_sig = 1;
        end
        6'b100011: begin
            alu_op_sig  = 2'b00;       // LW
            reg_wrt_sig  = 1;
            mem_read_sig = 1;
            mem_reg_sig  = 1;
            alu_src_sig  = 1;
        end
        6'b101011: begin
            alu_op_sig = 2'b00;        // SW
            mem_wrt_sig = 1;
            mem_reg_sig = 1;
            alu_src_sig = 1;
        end
        6'b000100: begin 
            alu_op_sig = 2'b01;        // BEQ
            branch_sig = 1;
        end
        6'b001101: begin
            alu_op_sig  = 2'b11;       // ORI
            alu_src_sig = 1;
            reg_wrt_sig = 1;
        end
        6'b000010: begin               // J
            jump_sig = 1;
        end
        default: alu_op_sig = 2'b10;
    endcase
end

ALUDecoder aluDecoder(alu_ctr_sig, alu_op_sig, funct);

endmodule