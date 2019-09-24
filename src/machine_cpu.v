// 16 bit Adder

`ifndef _CPU_V_
`define _CPU_V_ 

`include "cla4.v"

module machine_cpu(OUT, A, B);

input [15:0] OUT, A, B;

Add16 Add16_tst(OUT, A, B);

endmodule

`endif