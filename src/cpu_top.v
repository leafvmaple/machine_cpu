// 16 bit Adder

`ifndef _CPU_V_
`define _CPU_V_ 

`include "decoder.v"
`include "reg.v"
`include "pc.v"
`include "ir.v"

module CPU(addr_bus, data_bus_out, mem_read, mem_wrt, data_bus_in);

output [31:0] addr_bus;
output [31:0] data_bus_out;
output mem_read, mem_wrt;
input [31:0] data_bus_in;

wire [5:0] funct;
wire [4:0] rs, rt, rd, shamt;

wire [3:0] alu_ctr_sig;
wire [1:0] alu_op_sig;
wire reg_dst_sig, reg_wrt_sig, mem_reg_sig, alu_src_sig, branch_sig, zf;

wire [31:0] src_data, rt_data, alu_out;
wire [15:0] imm16_data;

reg clk, pc_clk;

reg [4:0] addr_dst;
wire [31:0] inst, addr_inst;
reg [31:0] reg_in, extra_data;
reg reg_wrt;

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
PC pc(addr_inst, zf & branch_sig, {{16{imm16_data[15]}}, imm16_data}, pc_clk);

/*Instruction Register*/
IRegister ir(inst, addr_inst, clk);

////////////////////////
///      Decode      ///
////////////////////////

/* Decoder */
Decoder decoder(alu_op_sig, reg_dst_sig, reg_wrt_sig, mem_read, mem_wrt, mem_reg_sig, alu_src_sig, branch_sig, rs, rt, rd, shamt, funct, inst);
ALUDecoder aluDecoder(alu_ctr_sig, alu_op_sig, funct);

always @(reg_dst_sig, rd, rt) begin
    if (reg_dst_sig) addr_dst = rd;
    else addr_dst = rt;
end

////////////////////
/// Visit Memery ///
////////////////////

/* Register */
Register register(src_data, rt_data, reg_wrt_sig, rs, rt, addr_dst, reg_in, clk);

assign imm16_data = {rd, shamt, funct};

always @(alu_src_sig, rt_data, rd, shamt, funct) begin
    if (alu_src_sig) extra_data = imm16_data;
    else extra_data = rt_data;
end

assign data_bus_out = rt_data;

////////////////////////
///      Excute      ///
////////////////////////
ALU alu(alu_out, zf, alu_ctr_sig, src_data, extra_data);

assign addr_bus = alu_out;

////////////////////////
///    Write Back    ///
////////////////////////

always @(mem_reg_sig, data_bus_in, alu_out) begin
    if (mem_reg_sig) reg_in = data_bus_in;
    else reg_in = alu_out;
end

endmodule

`endif