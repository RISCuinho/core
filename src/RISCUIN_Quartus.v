module RISCUIN_Quartus(
   input             CLOCK_50,
   output           [7:0]     LED
);

   wire rst;

   AutoReset aRst(.clk(CLOCK_50), .count(35), .rst(rst)); 
   RISCuin cpu(.clk(CLOCK_50), .rst(rst), .pc_end(LED[7]));



endmodule
