`ifdef __ICARUS__
`timescale 10ns/1ns
`endif

module RISCuin_tb;

	reg clk = 1'b0;

`ifndef __YOSYS__
	initial 
	begin
		forever 
			#2 clk = !clk;
	end
`endif 


	initial 
	begin
		#00000 $display("Iniciado!");
		$dumpfile("RISCuin.vcd");
		$dumpvars;
	 end

	wire  pc_end;

`ifndef __YOSYS__
	always @(posedge pc_end)
		if(pc_end) $finish;
`endif 

	wire rst;
	
	AutoReset aRst(.clk(clk), .count(30), .rst(rst)); 
   RISCuin cpu(.clk(clk), .rst(rst), .pc_end(pc_end));

endmodule
