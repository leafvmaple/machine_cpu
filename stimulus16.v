`include "add16.v"

module stimulus16;

reg [15:0] A, B, C;
reg SEL;
wire [15:0] OUT;

Add16 Add16_tst(OUT, A, B);

initial
begin
  //$monitor($time, " A = %b, OUT = %b ", A, OUT);
  $monitor($time, " A = %b, B = %b, OUT = %b ", A, B, OUT);
  //$monitor($time, " A = %b, B = %b, SEL = %b, OUT = %b ", A, B, SEL, OUT);
end

initial
begin
  A = 16'h0; B = 16'h0; C = 16'h0; SEL = 1'b0;
  #5 A = 16'h0; B = 16'h10; C = 16'h0; SEL = 1'b0;
  #5 A = 16'h10; B = 16'h0; C = 16'h0; SEL = 1'b0;
  #5 A = 16'h10; B = 16'h10; C = 16'h0; SEL = 1'b0;
  #5 A = 16'h0; B = 16'h0; C = 16'h10; SEL = 1'b1;
  #5 A = 16'h0; B = 16'h10; C = 16'h10; SEL = 1'b1;
  #5 A = 16'h10; B = 16'h0; C = 16'h10; SEL = 1'b1;
  #5 A = 16'h10; B = 16'h10; C = 16'h10; SEL = 1'b1;
  #5 A = 16'h100; B = 16'h10; C = 16'h1; SEL = 1'b1;
end

endmodule
