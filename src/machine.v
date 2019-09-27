// 16 bit Adder

`ifndef _MACHINE_V_
`define _MACHINE_V_ 

`include "cpu_top.v"
`include "mem.v"

module Board;

wire [31:0] addr_bus;
wire [31:0] data_bus_up, data_bus_down;

reg clk;

initial
begin
    clk = 0;
end

always #1 clk = ~clk;

Memory mem(data_bus_up, data_bus_down, addr_bus, mem_read, mem_wrt, clk);

CPU cpu(addr_bus, data_bus_down, mem_read, mem_wrt, data_bus_up);

endmodule

`endif