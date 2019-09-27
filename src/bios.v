`ifndef _BIOS_V_
`define _BIOS_V_ 

module BIOS(out, addr, clk);

output reg [31:0] out;
input [31:0] addr;
input clk;
reg [31:0] bios [31:0];

initial
begin
    bios[0] = 32'h00000000;
    bios[1] = 32'h34020026;
    bios[2] = 32'h34030034;
    bios[3] = 32'h00628020;
end

always @(posedge clk) begin
    out <= bios[addr];
end

endmodule

`endif