`include "add.v"
`include "mul.v"

module stimulus16;

reg [31:0] A, B, C;
reg SEL;
wire [31:0] OUT;
wire [63:0] OUT64;
wire carry;

//Add32 add(OUT, carry, A, B, SEL);
Mul32 mul(OUT64, A, B);

initial
begin
  //$monitor($time, " A = %b, OUT = %b ", A, OUT);
  $monitor($time, " A = %d, B = %d, OUT = %d ", A, B, OUT64);
  //$monitor($time, " A = %b, B = %b, SEL = %b, OUT = %b ", A, B, SEL, OUT);
end

initial
begin
  A = 32'h0;      B = 32'h0;  C = 32'h0;  SEL = 1'b0;
  #5 A = 32'h0;   B = 32'h10; C = 32'h0;  SEL = 1'b0;
  #5 A = 32'h10;  B = 32'h0;  C = 32'h0;  SEL = 1'b0;
  #5 A = 32'h10;  B = 32'h10; C = 32'h0;  SEL = 1'b0;
  #5 A = 32'h0;   B = 32'h0;  C = 32'h10; SEL = 1'b1;
  #5 A = 32'h0;   B = 32'h10; C = 32'h10; SEL = 1'b1;
  #5 A = 32'h10;  B = 32'h0;  C = 32'h10; SEL = 1'b1;
  #5 A = 32'h10;  B = 32'h10; C = 32'h10; SEL = 1'b1;
  #5 A = 32'h100; B = 32'h10; C = 32'h1;  SEL = 1'b1;
end

endmodule
