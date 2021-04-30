`include "config.vh"
`include "MemoryMap.vh"

module DataBusControl (
   input      rst,
   input      clk, wd, rd, 
   output reg busy,

   input      [1:0]            size_in, size_out,
	
   input      [31:0]           addr_in, addr_out,
	
   input      [31:0]				 data_in, 
   output     [31:0] 			 data_out,
   inout      [`GPIO_WIDTH-1:0] gpio
);

initial begin
   $display("GPIO total size: %d, total word (32bits) %d, GPIO BUS WIDTH: %d", 
                               `GPIO_ADDR_SIZE, `GPIO_ADDR_SIZE/32, `GPIO_WIDTH);
end

wire [31:0] local_data_out;

reg local_busy;
reg local_rst;

reg [31:0] memory [0:`DBC_RAM_SIZE];

reg [31:0] memory_tmp_in; // port 1
reg [31:0] memory_tmp_out; // port 2

reg [31:0] dbc_register;

wire ram_addr_out = (addr_out >= `DBC_RAM_START       && addr_out <= `DBC_RAM_END) ||
                    (addr_out >= `DBC_RAM_GLASS_START && addr_out <= `DBC_RAM_GLASS_END); 
wire ram_addr_in  = (addr_in  >= `DBC_RAM_START       && addr_in  <= `DBC_RAM_END) ||
                    (addr_in  >= `DBC_RAM_GLASS_START && addr_in  <= `DBC_RAM_GLASS_END);
wire gpio_addr_out = (addr_out >= `DBC_GPIO_ADDR_START && addr_out <= `DBC_GPIO_ADDR_END) ; 
wire gpio_addr_in  = (addr_in  >= `DBC_GPIO_ADDR_START && addr_in  <= `DBC_GPIO_ADDR_END);

wire [`DBC_RAM_ADDR_WIDTH-1:0] local_ram_addr_out = ram_addr_out ? 
                                                   addr_out[`DBC_RAM_ADDR_WIDTH-1:0]: 
                                                      {`DBC_RAM_ADDR_WIDTH{1'b0}}; 
wire [`DBC_RAM_ADDR_WIDTH-1:0] local_ram_addr_in  = ram_addr_out ?
                                                   addr_in[`DBC_RAM_ADDR_WIDTH-1:0] :
                                                      {`DBC_RAM_ADDR_WIDTH{1'b0}};
 
wire dbc_register_addrs = addr_out >= `DBC_REGISTER_START && addr_out <= `DBC_REGISTER_END;


wire [32:0] local_gpio_pos_in  = (addr_in -`DBC_GPIO_ADDR_START)*32;
wire [32:0] local_gpio_pos_out  = (addr_out -`DBC_GPIO_ADDR_START)*32;

assign local_data_out = (!rst && !busy && ram_addr_out && rd)  ?
                       size_out == 2'b00 ? {24'b0, memory_tmp_out[ 7:0]} :
                       size_out == 2'b01 ? {16'b0, memory_tmp_out[15:0]} :
                       size_out == 2'b10 ? memory_tmp_out : 32'b0 : 
                       32'b0;

wire [31:0] local_gpio_out = (!rst && !busy && gpio_addr_out && rd)  ?
                     size_out == 2 ?  {       gpio[local_gpio_pos_out +: 32]} :
                     size_out == 1 ?  {16'b0, gpio[local_gpio_pos_out +: 16]} :
                     size_out == 0 ?  {24'b0, gpio[local_gpio_pos_out +:  8]} :
                                       32'b0  :
                                       32'b0;

wire [31:0] local_gpio_32_in = (!rst && !local_busy && gpio_addr_in && wd)?
                                 size_in == 2 ?   data_in :
                                 size_in == 1 ?  {gpio[local_gpio_pos_in +: 16], data_in[15:0]}:
                                 size_in == 0 ?  {gpio[local_gpio_pos_in +: 24], data_in[ 7:0]}:
                                                  32'b0:
                                      32'b0;

assign gpio = (!rst && !local_busy && gpio_addr_in && wd) ? 
                                gpio :
                                gpio;

/*
assign gpio[local_gpio_pos_in +:  8] (!rst && !local_busy && gpio_addr_in && wd) ?data_in[7:0];
assign gpio[local_gpio_pos_in +: 16]
*/

assign data_out = dbc_register_addrs                                    ? // endereços dos registradores dbc
						
                  (addr_out == `DBC_REGISTER_MISALIGNED_EXCEPTION_ADDR || // registrador desalinhamento
						 addr_out == `DBC_REGISTER_EMPTY_ADDR_EXCPETION_ADDR) ?  // registrador endereço vazio/invalido
                   dbc_register[1:0]                                   : 
						
                   32'b1                                   :  // default para registradores dbc 

                  gpio_addr_out                                         ?
                  local_gpio_out                                        :
                  
                  local_data_out                                       ;  // outro dado endereçado

always @(posedge clk ) begin
   dbc_register[`DBC_REGISTER_EMPTY_ADDR_EXCEPTION_START_BIT] <=
                                 (!ram_addr_out && !ram_addr_in  &&
                                 !dbc_register_addrs) ; 
   // Lança uma exception se o endereço de memória estiver desalinhado
   // half-word cuida apenas do primeiro bit menos significativo 
   // word dos dois bits menos significativos.
   dbc_register[`DBC_REGISTER_MISALIGNED_EXCEPTION_START_BIT] <= 
                                 (addr_in[0]  != 1'b0 && (size_in == 2'b10 || size_in == 2'b01)) || 
                                 (addr_in[1]  != 1'b0 && size_in == 2'b10                      ) ||
                                 (addr_out[0] != 1'b0 && (size_in == 2'b10 || size_in == 2'b01)) ||
                                 (addr_out[1] != 1'b0 && size_in == 2'b10);

end


//Neste ponto deve ser parametrizado para identificar se 
// está sendo usado no simulador, no DE0-nano ou outros.
// se usa simulador é bem BRAM, se é DE0-Nano ou similar
// pode se usar BRAM mas melhor que use a DRAM que acompanha a placa
// se HUB75 também, já a TANG Nano preciso verificar.
initial begin
   local_rst <= 1'b0;
   busy <= 1'b0;
   local_busy <= 1'b0;
end

always @(*) begin
// busy não é usado exernamente ainda.
     busy <= local_busy;
     dbc_register[`DBC_REGISTER_BUS_BUSY_START_BIT] <= local_busy;
end

always @(posedge clk) begin

    memory_tmp_out <= memory[local_ram_addr_out]; // port 2

  if(rd) begin
//      $display("Memoria out 0h%08h => 0h%08h", addr_out, memory_tmp_out);
 //     $display("Registradores: %b",dbc_register_addrs);
   end
/*
  if(!rst && local_busy === 1'bx )begin
      local_busy <= 1'b1;
   end
*/
   else if(!rst && local_busy)begin
      local_busy <= 1'b0;
   end
end

always @(posedge clk) begin


   if(!rst && !local_busy && ram_addr_in)begin
      if(wd) begin
         //local_busy <= 1'b1;
         memory_tmp_in  <= memory[local_ram_addr_in];  // port 1
         memory[local_ram_addr_in] <= size_in == 2 ? data_in :
                                      size_in == 1 ? {memory_tmp_in[31:16],data_in[15:0]} :
                                      size_in == 0 ? {memory_tmp_in[31:8],data_in[7:0]} :
                                                     memory_tmp_in;
                                                     
//         $display("Memoria in 0h%08h <= 0h%08h", local_ram_addr_in, memory_tmp_in);
      end
   end
end
endmodule