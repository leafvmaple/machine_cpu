//  Memeries
`ifndef _PC_V_
`define _PC_V_

module Mem(out, wrt_sig, addr, in, clk);

output [31:0] out;
input wrt_sig;
input [31:0] in;
input clk;

reg [31:0] mem[256:0];

assign out = mem[addr];

always @(posedge clk) begin
    if (wrt_sig) men[addr] = in;
    $display($time, " [Memory] reg_wrt = %d addr_wrt = %d in = %d", wrt_sig, addr_wrt, mem[addr_wrt]);
end

endmodule

`endif