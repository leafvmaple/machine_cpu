// 16 bit Adder

`ifndef _CPU_V_
`define _CPU_V_ 

`include "decoder.v"
`include "reg.v"
`include "pc.v"
`include "bios.v"

module CPU;

wire [31:0] inst;

wire [5:0] funct;
wire [4:0] rs, rt, rd, shamt;

wire [3:0] aluCtrSig;
wire [1:0] aluOpSig;
wire regDstSig, aluImmSig, regWrSig;

wire [31:0] a, b, out;
wire [31:0] regSrc0, regSrc1, regDst;

reg clk, pcClock;

reg [4:0] addrDst;
reg [31:0] ir, aluOpr1;

wire [31:0] addrIr;

initial
begin
    #1 clk = 0;
    pcClock = 0;
end

always #1 clk = ~clk;

always @(clk) begin
    #3 pcClock = ~pcClock;
end

PC pc(addrIr, , ,pcClock);
BIOS bios(inst, addrIr, clk);

/*
If Not Use IR, the Inst may be change when the signal transmit to Register Files
*/
always @(posedge clk) begin // Instruction Register
    ir = inst;
    $display($time, " [IR] Instruction = %b", ir);
end

Decoder decoder(aluOpSig, regDstSig, regWrSig, aluImmSig, rs, rt, rd, shamt, funct, ir);
ALUDecoder aluDecoder(aluCtrSig, aluOpSig, funct);

always @(regDstSig, rd, rt) begin
    if (regDstSig) addrDst = rd;
    else addrDst = rt;
end

Register register(regSrc0, regSrc1, regWrSig, rs, rt, addrDst, regDst, clk);

always @(aluImmSig, regSrc1, rd, shamt, funct) begin
    if (aluImmSig) aluOpr1 = {rd, shamt, funct};
    else aluOpr1 = regSrc1;
end

ALU alu(regDst, aluCtrSig, regSrc0, aluOpr1);

endmodule

`endif