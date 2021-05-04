`include "config.vh"
`include "MemoryMap.vh"

module DataBusControl #(
 localparam ram_byte_select_limit = (`DBC_RAM_DATA_SIZE+7)/8-1
)(
   input      rst,
   input      clk, wd, rd, 
   output     busy,

   input      [1:0]             size,
	
   input      [31:0]            addr,
	
   input      [31:0]			data_in, 
   output     [31:0] 			data_out,
   inout      [`GPIO_WIDTH-1:0] gpio
);

initial begin
   $display("GPIO total size: %d, total word (32bits) %d, GPIO BUS WIDTH: %d", 
                               `GPIO_ADDR_SIZE, `GPIO_ADDR_SIZE/32, `GPIO_WIDTH);
end

wire is_ram_addr  = (addr >= `DBC_RAM_START) && (addr <= `DBC_RAM_END) ||
                    (addr >= `DBC_RAM_GLASS_START) && (addr <= `DBC_RAM_GLASS_END);
wire is_gpio_addr = (addr >= `DBC_GPIO_ADDR_START) && (addr <= `DBC_GPIO_ADDR_END);

wire [`DBC_RAM_ADDR_WIDTH-1:0] ram_addr = addr[`DBC_RAM_ADDR_WIDTH-1:0];

wire [`DBC_RAM_DATA_SIZE-1:0] ram_data_out, ram_data_in;
/*
  00 -> 8bits
  01 -> 16bits 
  10 -> 32bits 
*/
wire [ram_byte_select_limit:0] ram_byte_select = size == 2'b10 ? 4'b1111 :
                                                 size == 2'b01 ? 4'b0011 :
                                                 size == 2'b00 ? 4'b0001 :
                                                                 4'b0000 ;
rl_ram_1r1w_generic #(
                 .ABITS(`DBC_RAM_ADDR_WIDTH),
                 .DBITS(`DBC_RAM_DATA_SIZE)) 
          memory(.rst_ni(rst), .clk_i(clk), .we_i(is_ram_addr && wd),
                 .waddr_i(ram_addr[`DBC_RAM_ADDR_WIDTH-1:2]),
                 .be_i(ram_byte_select),
                 .din_i(data_in),
                 .raddr_i(ram_addr[`DBC_RAM_ADDR_WIDTH-1:2]),
                 .dout_o(data_out));

assign gpio = (is_gpio_addr && wd)? data_out[`GPIO_WIDTH-1:0] : {`GPIO_WIDTH{1'bz}} ;

endmodule
