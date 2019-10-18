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

reg [31:0] pc_added_id, inst_id;

// ID
wire [4:0] rs, rt, rd;
wire [3:0] alu_ctr_sig;
wire reg_dst_sig, reg_wrt_sig, mem_read_rig, mem_wrt_rig, mem_reg_sig, alu_src_sig, branch_sig, jump_sig;
wire [31:0] src_data, rt_data;

wire [15:0] imm16_data;
wire [25:0] imm26_data;
wire [31:0] imm32_data;
wire [31:0] pc_jump;

reg [31:0] src_data_ex, rt_data_ex;
reg [31:0] imm32_data_ex, pc_added_ex, pc_jump_ex;

reg [3:0] alu_ctr_sig_ex;
reg mem_read_rig_ex, mem_wrt_rig_ex, mem_reg_sig_ex, alu_src_sig_ex, branch_sig_ex, jump_sig_ex;

// EX
wire zf;
wire [31:0] alu_out;
wire [31:0] pc_branched, pc_back;

reg [31:0] rt_data_mem;
reg [31:0] alu_out_mem;
reg mem_read_rig_mem, mem_wrt_rig_mem, mem_reg_sig_mem;

// MEM
wire [31:0] mem_out;

reg [31:0] alu_out_wb;
reg [31:0] mem_out_wb;
reg mem_reg_sig_wb;

// WB
wire [31:0] back_data;

/*Initial*/
initial
begin
    clk = 0;
    inst_id = 0;
    branch_sig_ex = 0;
    jump_sig_ex = 0;
end

always #1 clk = ~clk;

/////////////////////////
/// Instruction Fetch ///
/////////////////////////

/* Program Counter */
PC pc(pc_out, (branch_sig_ex | jump_sig_ex) ? pc_back : pc_added, clk);

assign pc_added = pc_out + 4;

/* Instruction Register */
IRegister ir(inst, pc_out, clk);

always @(posedge clk) begin
    pc_added_id = pc_added;
    inst_id = inst;
end

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
                inst_id);

/* Register */
Register register(src_data,
                  rt_data,
                  reg_wrt_sig,
                  rs,
                  rt,
                  reg_dst_sig ? rd : rt,
                  back_data,
                  clk);

assign imm16_data = inst_id[15:0];
assign imm26_data = inst_id[25:0];

assign imm32_data = {{16{imm16_data[15]}}, imm16_data};
assign pc_jump = {pc_added_id[31:28], imm26_data << 2};

always @(posedge clk) begin
    src_data_ex = src_data;
    rt_data_ex = rt_data;
    imm32_data_ex = imm32_data;
    pc_added_ex = pc_added_id;
    pc_jump_ex = pc_jump;

    // Control
    alu_ctr_sig_ex = alu_ctr_sig;
    mem_read_rig_ex = mem_read_rig;
    mem_wrt_rig_ex = mem_wrt_rig;
    mem_reg_sig_ex = mem_reg_sig;
    alu_src_sig_ex = alu_src_sig;
    branch_sig_ex = branch_sig;
    jump_sig_ex = jump_sig;
end

////////////////////
///    Excute    ///
////////////////////
ALU alu(alu_out, zf, alu_ctr_sig_ex, src_data_ex, alu_src_sig_ex ? imm32_data_ex : rt_data_ex);

assign pc_branched = (zf & branch_sig_ex)? (pc_added_ex + imm32_data_ex << 2) : pc_added_ex;
assign pc_back = jump_sig_ex ? pc_jump_ex : pc_branched;

always @(posedge clk) begin
    alu_out_mem = alu_out;
    rt_data_mem = rt_data_ex;
    mem_read_rig_mem = mem_read_rig_ex;
    mem_wrt_rig_mem = mem_wrt_rig_ex;
    mem_reg_sig_mem = mem_reg_sig_ex;
end

////////////////////
///    Memery    ///
////////////////////

/* Cache Memory */
Memory mem(mem_out, rt_data_mem, alu_out_mem, mem_read_rig_mem, mem_wrt_rig_mem, clk);

always @(posedge clk) begin
    mem_out_wb = mem_out;
    alu_out_wb = alu_out_mem;
    mem_reg_sig_wb = mem_reg_sig_mem;
end

////////////////////////
///    Write Back    ///
////////////////////////
assign back_data = mem_reg_sig_wb ? mem_out_wb : alu_out_wb;

endmodule

`endif