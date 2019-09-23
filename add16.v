// 16 bit Adder

`ifndef _ADD16_V_
`define _ADD16_V_ 

`include "cla4.v"

module Add16(out, a, b);

output [15:0] out;
input [15:0] a, b;

wire [3:0] c, g, p;

CLABase4 clabase(c, g, p, c0);

BCLA4 bcla0(out[3:0],   g[0], p[0], a[3:0],   b[3:0],   1'b0);
BCLA4 bcla1(out[7:4],   g[1], p[1], a[7:4],   b[7:4],   c[0]);
BCLA4 bcla2(out[11:8],  g[2], p[2], a[11:8],  b[11:8],  c[1]);
BCLA4 bcla3(out[15:12], g[3], p[3], a[15:12], b[15:12], c[2]);

/*CLA4 cla0(out[3:0],   c[0], a[3:0],   b[3:0],   1'b0);
CLA4 cla1(out[7:4],   c[1], a[7:4],   b[7:4],   c[0]);
CLA4 cla2(out[11:8],  c[2], a[11:8],  b[11:8],  c[1]);
CLA4 cla3(out[15:12], c[3], a[15:12], b[15:12], c[2]);*/

endmodule

`endif