// 16 bit Adder

`ifndef _CPU_V_
`define _CPU_V_ 

`include "decoder.v"

module CPU(inst);

input [31:0] inst;

wire [5:0] funct;
wire [4:0] rs, rt, rd, shamt;
wire [3:0] aluCtr;
wire [1:0] aluOp;

wire [31:0] a, b, out;

reg [31:0] regs[31:0];

Decoder decoder(aluOp, rs, rt, rd, funct, inst);
ALUDecoder aluDecoder(aluCtr, aluOp, funct);

ALU alu(regs[rd], aluCtr, regs[rs], regs[rt]);

endmodule

`endif