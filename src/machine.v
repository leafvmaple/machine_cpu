// 16 bit Adder

`ifndef _MACHINE_V_
`define _MACHINE_V_ 

`include "cpu_top.v"
`include "bios.v"
`include "mem.v"

module Board;

wire [31:0] addr_bus;
wire [31:0] data_bus;

reg clk;

initial
begin
    clk = 0;
end

always #1 clk = ~clk;

BIOS bios(data_bus, addr_bus, clk);

CPU cpu(addr_bus, data_bus);

endmodule

`endif