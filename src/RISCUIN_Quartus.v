module RISCUIN_Quartus(

	//////////// CLOCK //////////
	input 		          		CLOCK_50,

	//////////// LED //////////
	output		     [7:0]		LED,

	//////////// KEY //////////
	input 		     [1:0]		KEY,

	//////////// SW //////////
	input 		     [3:0]		SW,

	//////////// SDRAM //////////
	output		    [12:0]		DRAM_ADDR,
	output		     [1:0]		DRAM_BA,
	output		          		DRAM_CAS_N,
	output		          		DRAM_CKE,
	output		          		DRAM_CLK,
	output		          		DRAM_CS_N,
	inout 		    [15:0]		DRAM_DQ,
	output		     [1:0]		DRAM_DQM,
	output		          		DRAM_RAS_N,
	output		          		DRAM_WE_N,

	//////////// EEPROM //////////
	output		          		I2C_SCLK,
	inout 		          		I2C_SDAT
);


	wire rst;

	AutoReset aRst(.clk(CLOCK_50), .count(35), .rst(rst)); 
   RISCuin cpu(.clk(CLOCK_50), .rst(rst), .pc_end(LED[7]));



endmodule
