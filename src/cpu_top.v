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

reg clk, pc_clk;

wire [31:0] inst, addr_inst;

wire [4:0] rs, rt, rd;
wire [3:0] alu_ctr_sig;
wire reg_dst_sig, reg_wrt_sig, mem_reg_sig, alu_src_sig, branch_sig, jump_sig;

wire [31:0] src_data, rt_data;

wire [15:0] imm16_data;
wire [25:0] imm26_data;

wire zf;
wire [31:0] alu_out;


/*Initial*/
initial
begin
    clk = 0;
    pc_clk = 0;
end

always #1 clk = ~clk;

always @(clk) #4 pc_clk = ~pc_clk;

////////////////////////
/// Load Instruction ///
////////////////////////

/*Program Counter*/
PC pc(addr_inst, zf & branch_sig, jump_sig, imm16_data, imm26_data, pc_clk);

/*Instruction Register*/
IRegister ir(inst, addr_inst, clk);

////////////////////////
///      Decode      ///
////////////////////////

/* Decoder */
Decoder decoder(alu_ctr_sig,
                reg_dst_sig,
                reg_wrt_sig,
                mem_read,
                mem_wrt,
                mem_reg_sig,
                alu_src_sig,
                branch_sig,
                jump_sig,
                rs,
                rt,
                rd,
                inst);

////////////////////
/// Visit Memery ///
////////////////////

/* Register */
Register register(src_data,
                  rt_data,
                  reg_wrt_sig,
                  rs,
                  rt,
                  reg_dst_sig ? rd : rt,
                  mem_reg_sig ? data_bus_in : alu_out,
                  clk);

assign imm16_data = inst[15:0];
assign imm26_data = inst[25:0];
assign data_bus_out = rt_data;

////////////////////////
///      Excute      ///
////////////////////////
ALU alu(alu_out, zf, alu_ctr_sig, src_data, alu_src_sig ? imm16_data : rt_data);

////////////////////////
///    Write Back    ///
////////////////////////
assign addr_bus = alu_out;

endmodule

`endif