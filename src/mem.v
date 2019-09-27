//  Memeries
`ifndef _MEM_V_
`define _MEM_V_

module Memory(out, in, addr, mem_read_sig, mem_wrt_sig, clk);

output reg [31:0] out;
input [31:0] in;
input [31:0] addr;
input mem_read_sig, mem_wrt_sig;
input clk;

reg [31:0] mem[256:0];

always @(mem_read_sig) out = mem[addr];

always @(posedge clk) begin
    if (mem_wrt_sig) mem[addr] = in;
    $display($time, " [Memory] addr = %d in = %d", addr, mem[addr]);
end

endmodule

`endif