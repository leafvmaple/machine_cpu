// 16 bit Adder

`ifndef _CPU_V_
`define _CPU_V_ 

`include "decoder.v"
`include "reg.v"
`include "pc.v"
`include "ir.v"
`include "mem.v"

module CPU;

reg clk, pc_clk;

// IF
wire [31:0] inst, addr_inst;

// ID
wire [4:0] rs, rt, rd;
wire [3:0] alu_ctr_sig;
wire reg_dst_sig, reg_wrt_sig, mem_read_rig, mem_wrt_rig, mem_reg_sig, alu_src_sig, branch_sig, jump_sig;
wire [31:0] src_data, rt_data;

wire [15:0] imm16_data;
wire [25:0] imm26_data;

// EX
wire zf;
wire [31:0] alu_out;

// MEM
wire [31:0] mem_out;

// WB
wire [31:0] back_data;


/*Initial*/
initial
begin
    clk = 0;
    pc_clk = 0;
end

always #1 clk = ~clk;

always @(clk) #4 pc_clk = ~pc_clk;

/////////////////////////
/// Instruction Fetch ///
/////////////////////////

/* Program Counter */
PC pc(addr_inst, zf & branch_sig, jump_sig, imm16_data, imm26_data, pc_clk);

/* Instruction Register */
IRegister ir(inst, addr_inst, clk);

//////////////////////////
/// Instruction Decode ///
//////////////////////////

/* Decoder */
Decoder decoder(alu_ctr_sig,
                reg_dst_sig,
                reg_wrt_sig,
                mem_read_rig,
                mem_wrt_rig,
                mem_reg_sig,
                alu_src_sig,
                branch_sig,
                jump_sig,
                rs,
                rt,
                rd,
                inst);

/* Register */
Register register(src_data,
                  rt_data,
                  reg_wrt_sig,
                  rs,
                  rt,
                  reg_dst_sig ? rd : rt,
                  back_data,
                  clk);

assign imm16_data = inst[15:0];
assign imm26_data = inst[25:0];

////////////////////
///    Excute    ///
////////////////////
ALU alu(alu_out, zf, alu_ctr_sig, src_data, alu_src_sig ? imm16_data : rt_data);

////////////////////
///    Memery    ///
////////////////////

/* Cache Memory */
Memory mem(mem_out, rt_data, alu_out, mem_read_rig, mem_wrt_rig, clk);

////////////////////////
///    Write Back    ///
////////////////////////
assign back_data = mem_reg_sig ? mem_out : alu_out;

endmodule

`endif