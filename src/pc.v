`ifndef _PC_V_
`define _PC_V_

module PC(out, branch_sig, jump_sig, branch_in, jump_in, clk);

output [31:0] out;
input branch_sig, jump_sig;
input [15:0] branch_in;
input [25:0] jump_in;
input clk;

wire [31:0] signed_branch_in;

reg [31:0] pc;

initial
begin
    pc = 0;
end

assign out = pc;
assign signed_branch_in = {{16{branch_in[15]}}, branch_in};

always @(posedge clk) begin
    pc = pc + 4;
    if (branch_sig) pc = pc + (signed_branch_in << 2);
    else if (jump_sig) pc = {pc[31:28], jump_in << 2};
    else pc = pc;
    $display($time, " [PC] Update = %d branch_sig = %b jump_sig = %d ---- ", pc, branch_sig, jump_sig);
end

endmodule

`endif