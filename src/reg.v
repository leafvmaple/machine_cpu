`ifndef _REG_V_
`define _REG_V_ 

module Register(out0, out1, regWr, addr0, addr1, addrWr, in, clk);

output [31:0] out0, out1;
input regWr, clk;
input [4:0] addr0, addr1, addrWr;
input [31:0] in;

reg [31:0] regfile[31:0];

initial
begin
    regfile[0] = 0;
end

assign out0 = regfile[addr0];
assign out1 = regfile[addr1];

always @(posedge clk) begin
    if (regWr) regfile[addrWr] = in;
    $display($time, " [Register] regWr = %d addrWr = %d in = %d", regWr, addrWr, regfile[addrWr]);
end

endmodule

`endif