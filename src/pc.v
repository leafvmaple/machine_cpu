`ifndef _PC_V_
`define _PC_V_

module PC(out, jump_sig, in, clk);

output [31:0] out;
input jump_sig;
input [31:0] in;
input clk;

reg [31:0] pc;

initial
begin
    pc = 0;
end

assign out = pc;

always @(posedge clk) begin
    pc = pc + 4;
    if (jump_sig) pc = pc + (in << 2);
    else pc = pc;
    $display($time, " [PC] Update = %d jump_sig = %b in = %d --------------------- ", pc, jump_sig, in);
end

endmodule

`endif