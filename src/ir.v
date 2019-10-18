`ifndef _IR_V_
`define _IR_V_

module IRegister(out, addr, clk);

output reg [31:0] out;
input [31:0] addr;
input clk;
reg [7:0] ir[127:0];

reg [31:0] in[31:0];

integer i;
initial
begin
    in[0] = 32'h00000000;
    in[1] = 32'h34020026;
    in[2] = 32'h34030034;
    in[3] = 32'h00628020;
    in[4] = 32'hae020001;
    in[5] = 32'h8e030001;
    //in[6] = 32'h1043fffd;
    //in[6] = 32'h08000003;

    for (i = 0; i < 32; i++)
        {ir[i * 4 + 3], ir[i * 4 + 2], ir[i * 4 + 1], ir[i * 4]} = in[i];
end

always @(posedge clk, addr) begin
    out = {ir[addr + 3], ir[addr + 2], ir[addr + 1], ir[addr]};
    $display($time, " [1 IR] Instruction = %b", out);
end

endmodule

`endif