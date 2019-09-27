`ifndef _PC_V_
`define _PC_V_

module PC(out, pcWr, in, clk);

output [31:0] out;
input pcWr;
input [31:0] in;
input clk;

reg [31:0] pc;

initial
begin
    pc = 0;
end

assign out = pc;

always @(posedge clk) begin
    if (pcWr) pc = in;
    else pc = pc + 1;
    $display($time, " [PC] Update = %d", pc);
end

endmodule

`endif