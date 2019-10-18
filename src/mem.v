//  Memeries
`ifndef _MEM_V_
`define _MEM_V_

module Memory(out, in, addr, mem_read_sig, mem_wrt_sig, clk);

output reg [31:0] out;
input [31:0] in;
input [31:0] addr;
input mem_read_sig, mem_wrt_sig;
input clk;

reg [7:0] mem[1023:0];

always @(mem_read_sig) out = {mem[addr + 3], mem[addr + 2], mem[addr + 1], mem[addr]};

always @(posedge clk) begin
    if (mem_wrt_sig) {mem[addr + 3], mem[addr + 2], mem[addr + 1], mem[addr]} = in;
    $display($time, " [4 Memory] addr = %d out = %d in = %d", addr, out, in);
end

endmodule

`endif