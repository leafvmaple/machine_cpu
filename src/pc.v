`ifndef _PC_V_
`define _PC_V_

module PC(out, in, clk);

output [31:0] out;
input [31:0] in;
input clk;

reg [31:0] pc;

initial
begin
    pc = 0;
end

assign out = pc;

always @(posedge clk) begin
    pc = in;
    $display($time, " [1 PC] Update = %d -----------------------------", in);
end

endmodule

`endif