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
wire [31:0] pc_out, pc_added;
wire [31:0] inst;

// ID
wire [4:0] rs, rt, rd;
wire [3:0] alu_ctr_sig;
wire reg_dst_sig, reg_wrt_sig, mem_read_rig, mem_wrt_rig, mem_reg_sig, alu_src_sig, branch_sig, jump_sig;
wire [31:0] src_data, rt_data;

wire [15:0] imm16_data;
wire [25:0] imm26_data;
wire [31:0] imm32_data;
wire [31:0] pc_jump;

// EX
wire zf;
wire [31:0] alu_out;
wire [31:0] pc_branched, pc_back;

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
PC pc(pc_out, pc_back, pc_clk);

assign pc_added = pc_out + 4;

/* Instruction Register */
IRegister ir(inst, pc_out, clk);

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

assign imm32_data = {{16{imm16_data[15]}}, imm16_data};
assign pc_jump = {pc_added[31:28], imm26_data << 2};

////////////////////
///    Excute    ///
////////////////////
ALU alu(alu_out, zf, alu_ctr_sig, src_data, alu_src_sig ? imm32_data : rt_data);

assign pc_branched = (zf & branch_sig)? (pc_added + imm32_data << 2) : pc_added;
assign pc_back = jump_sig ? pc_jump : pc_branched;

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