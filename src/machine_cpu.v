// 16 bit Adder

`ifndef _CPU_V_
`define _CPU_V_ 

`include "decoder.v"
`include "reg.v"

module CPU(inst);

input [31:0] inst;

wire [5:0] funct;
wire [4:0] rs, rt, rd, shamt;
wire [3:0] aluCtr;
wire [1:0] aluOp;

wire [31:0] a, b, out;
wire [31:0] sreg, treg, dreg;

reg clk;

initial
begin
    #1 clk = 1;
    #1 clk = 0;
end

Decoder decoder(aluOp, rs, rt, rd, funct, inst);
ALUDecoder aluDecoder(aluCtr, aluOp, funct);

Register register(sreg, treg, 1'b1, rs, rt, rd, dreg, clk);

ALU alu(dreg, aluCtr, sreg, treg);

endmodule

`endif