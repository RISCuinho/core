`include "config.vh"
`include "MemoryMap.vh"

module DataBusControl (
   input      rst,
   input      clk, wd, rd, 
   output reg busy,

   input      [1:0]            size,
	
   input      [31:0]           addr,
	
   input      [31:0]				 data_in, 
   output     [31:0] 			 data_out,
   inout      [`GPIO_WIDTH-1:0] gpio
);

initial begin
   $display("GPIO total size: %d, total word (32bits) %d, GPIO BUS WIDTH: %d", 
                               `GPIO_ADDR_SIZE, `GPIO_ADDR_SIZE/32, `GPIO_WIDTH);
end


DataMemory #(.ADDR_WIDTH(`DBC_RAM_ADDR_WIDTH), .DATA_WIDTH(32)) memory(
                    .clk(clk), .wd(wd), .rd(rd),
                    .addr(addr),
                    .size(size),
                    .data_in(ram_data_in), 
                    .data_out(ram_data_out));


endmodule
