// 16 bit Adder

`ifndef _CPU_V_
`define _CPU_V_ 

`include "decoder.v"
`include "reg.v"
`include "pc.v"
`include "bios.v"

module CPU(addr_bus, data_bus);

output [31:0] addr_bus;
input [31:0] data_bus;

wire [5:0] funct;
wire [4:0] rs, rt, rd, shamt;

wire [3:0] alu_ctr_sig;
wire [1:0] alu_op_sig;
wire reg_dst_sig, alu_imm_sig, wrt_sig;

wire [31:0] src_data, reg_src1, dst_data;

reg clk, pc_clk;

reg [4:0] addr_dst;
reg [31:0] ir, alu_operand;

/*Initial*/
initial
begin
    clk = 0;
    pc_clk = 0;
end

always #1 clk = ~clk;

always @(clk) #2.5 pc_clk = ~pc_clk;

////////////////////////
/// Load Instruction ///
////////////////////////

/*Program Counter*/
PC pc(addr_bus, , ,pc_clk);

/*Instruction Register*/
always @(posedge clk) begin // Instruction Register
    ir = data_bus;
    $display($time, " [IR] Instruction = %b", ir);
end

////////////////////////
///      Decode      ///
////////////////////////

/* Decoder */
Decoder decoder(alu_op_sig, reg_dst_sig, wrt_sig, alu_imm_sig, rs, rt, rd, shamt, funct, ir);
ALUDecoder aluDecoder(alu_ctr_sig, alu_op_sig, funct);

always @(reg_dst_sig, rd, rt) begin
    if (reg_dst_sig) addr_dst = rd;
    else addr_dst = rt;
end

////////////////////////////
/// Visit Memery & Write ///
////////////////////////////

/* Register */
Register register(src_data, reg_src1, wrt_sig, rs, rt, addr_dst, dst_data, clk);

always @(alu_imm_sig, reg_src1, rd, shamt, funct) begin
    if (alu_imm_sig) alu_operand = {rd, shamt, funct};
    else alu_operand = reg_src1;
end

////////////////////////
///      Excute      ///
////////////////////////
ALU alu(dst_data, alu_ctr_sig, src_data, alu_operand);

endmodule

`endif