`ifndef _REG_V_
`define _REG_V_ 

module Register(out0, out1, wrt_sig, addr0, addr1, addr_wrt, in, clk);

output [31:0] out0, out1;
input wrt_sig, clk;
input [4:0] addr0, addr1, addr_wrt;
input [31:0] in;

reg [31:0] regfile[31:0];

initial
begin
    regfile[0] = 0;
end

assign out0 = regfile[addr0];
assign out1 = regfile[addr1];

always @(posedge clk) begin
    if (wrt_sig) regfile[addr_wrt] = in;
    $display($time, " [Register] wrt_sig = %d addr_wrt = %d in = %d", wrt_sig, addr_wrt, regfile[addr_wrt]);
end

endmodule

`endif