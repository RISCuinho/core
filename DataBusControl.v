`include "MemoryMap.vh"

module DataBusControl (
   input      rst,
   input      clk, wd, rd, 
   output     ready, // ready == 0 is busy
   input      [1:0]            size_in, size_out,
	
   input                       unsigned_value,
	
   input      [31:0]           addr_in, addr_out,
	
   input      [31:0]				 data_in, 
   output     [31:0] 			 data_out
);

//localparam SIZE = 2**ADDR_WIDTH;

reg [31:0] dbc_register;

assign ready = 1'b1;

reg [31:0] local_data_out;

wire ram_addrs = (addr_out >= `DBC_RAM_START && addr_out <= `DBC_RAM_END) || 
                 (addr_in  >= `DBC_RAM_START && addr_in  <= `DBC_RAM_END);
wire dbc_register_addrs = addr_out >= `DBC_REGISTER_START || addr_out <= `DBC_REGISTER_END;

assign data_out = dbc_register_addrs                                    ? // endereços dos registradores dbc
						
                  (addr_out == `DBC_REGISTER_MISALIGNED_EXCEPTION_ADDR || // registrador desalinhamento
						 addr_out == `DBC_REGISTER_EMPTY_ADDR_EXCPETION_ADDR) ?  // registrador endereço vazio/invalido
                  dbc_register[31:0]                                   : 
						
                  dbc_register[31:0]                                   :  // default para registradores dbc 

						local_data_out                                       ;  // outro dado endereçado
						

always @(posedge clk ) begin
   dbc_register[`DBC_REGISTER_EMPTY_ADDR_EXCEPTION_BIT] <=
                                 !ram_addrs &&
                                 !dbc_register_addrs ; 
   // Lança uma exception se o endereço de memória estiver desalinhado
   // half-word cuida apenas do primeiro bit menos significativo 
   // word dos dois bits menos significativos.
   dbc_register[`DBC_REGISTER_MISALIGNED_EXCEPTION_BIT] <= 
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

wire [4:0] idx; // contador para operações half,word, double, quardword; interrompe o contador do pc.

reg [31:0] memory [0:`DBC_RAM_SIZE];

always @(posedge clk) begin
   if(!rst && ready)begin
      if(wd)begin
         case (size_in)
            2'b10: // 32bits
               memory[addr_in] <= data_in;
            2'b01: // 16bits
               memory[addr_in] <= {memory[addr_in][31:16],data_in[15:0]};
            2'b00: // 8bits
               memory[addr_in] <= {memory[addr_in][31:8],data_in[7:0]};
         endcase
      end
   end
end
endmodule
