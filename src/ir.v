`ifndef _IR_V_
`define _IR_V_

module IRegister(out, addr, clk);

output reg [31:0] out;
input [31:0] addr;
input clk;
reg [31:0] ir [31:0];

initial
begin
    ir[0] = 32'h00000000;
    ir[1] = 32'h34020026;
    ir[2] = 32'h34030034;
    ir[3] = 32'h00628020;
    ir[4] = 32'hae020001;
    ir[5] = 32'h8e030001;
end

always @(posedge clk) begin
    out = ir[addr];
    $display($time, " [IR] Instruction = %b", ir[addr]);
end

endmodule

`endif