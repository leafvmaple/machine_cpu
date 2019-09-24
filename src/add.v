// 16 bit Adder

`ifndef _ADD_V_
`define _ADD_V_ 

`include "config.v"
`include "cla4.v"

module Add16(out, carry, a, b, c0);

output [15:0] out;
output carry;
input [15:0] a, b;
input c0;

wire [3:0] c, g, p;

`ifdef _BCLA
    CLABase4 clabase(c, g, p, c0);
    BCLA4 bcla0(out[3:0],   g[0], p[0], a[3:0],   b[3:0],   1'b0);
    BCLA4 bcla1(out[7:4],   g[1], p[1], a[7:4],   b[7:4],   c[0]);
    BCLA4 bcla2(out[11:8],  g[2], p[2], a[11:8],  b[11:8],  c[1]);
    BCLA4 bcla3(out[15:12], g[3], p[3], a[15:12], b[15:12], c[2]);
`else
    CLA4 cla0(out[3:0],   c[0], a[3:0],   b[3:0],   1'b0);
    CLA4 cla1(out[7:4],   c[1], a[7:4],   b[7:4],   c[0]);
    CLA4 cla2(out[11:8],  c[2], a[11:8],  b[11:8],  c[1]);
    CLA4 cla3(out[15:12], c[3], a[15:12], b[15:12], c[2]);
`endif
assign carry = c[3];

endmodule

module Add32(out, carry, a, b, c0);

output [31:0] out;
output carry;
input [31:0] a, b;
input c0;

wire c1;

Add16 add0(out[15:0], c1, a[15:0], b[15:0], c0);
Add16 add1(out[31:16], carry, a[31:16], b[31:16], c1);

endmodule

`endif