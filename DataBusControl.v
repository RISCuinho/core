`include "MemoryMap.vh"

module DataBusControl (
   input      rst,
   input      clk, wd, rd, 
   output reg ready, 
   output reg busy,

   input      [1:0]            size_in, size_out,
	
   input      [31:0]           addr_in, addr_out,
	
   input      [31:0]				 data_in, 
   output     [31:0] 			 data_out
);


wire [31:0] local_data_out;

reg local_busy;
reg local_rst;

reg [31:0] memory [0:`DBC_RAM_SIZE];
reg [31:0] dbc_register;

wire ram_addr_out = addr_out >= `DBC_RAM_START && addr_out <= `DBC_RAM_END; 
wire ram_addr_in  = addr_in  >= `DBC_RAM_START && addr_in  <= `DBC_RAM_END;

wire dbc_register_addrs = addr_out >= `DBC_REGISTER_START && addr_out <= `DBC_REGISTER_END;

assign local_data_out = (!rst && ready && !busy && ram_addr_out && rd)  ?
                       size_out == 2'b00 ? {24'b0, memory[addr_out][ 7:0]} :
                       size_out == 2'b01 ? {16'b0, memory[addr_out][15:0]} :
                       size_out == 2'b10 ? memory[addr_out] : 32'b0 : 
                       32'b0;

assign data_out = dbc_register_addrs                                    ? // endereços dos registradores dbc
						
                  (addr_out == `DBC_REGISTER_MISALIGNED_EXCEPTION_ADDR || // registrador desalinhamento
						 addr_out == `DBC_REGISTER_EMPTY_ADDR_EXCPETION_ADDR) ?  // registrador endereço vazio/invalido
                   dbc_register[31:0]                                   : 
						
                   32'b1                                   :  // default para registradores dbc 

						local_data_out                                       ;  // outro dado endereçado

always @(posedge clk ) begin
   dbc_register[`DBC_REGISTER_EMPTY_ADDR_EXCEPTION_START_BIT] <=
                                 !ram_addr_out && !ram_addr_in  &&
                                 !dbc_register_addrs ; 
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
   local_rst <= 1'bx;
   busy <= 1'bx;
   local_busy <= 1'bx;
   ready <= 1'b1;
end

always @(*) begin
// busy não é usado exernamente ainda.
//     busy <= local_busy;
      busy <=1'b0;
     dbc_register[`DBC_REGISTER_BUS_BUSY_START_BIT] <= local_busy;
end

always @(posedge clk) begin

  if(rd) begin
      $display("Memoria out 0h%08h => 0h%08h", addr_out, memory[addr_out]);
      $display("Registradores: %b",dbc_register_addrs);
   end
  if(!rst && local_busy === 1'bx )begin
      ready <= 1'b1;
      local_busy <= 1'b1;
   end
   else if(!rst && ready && local_busy)begin
      local_busy <= 1'b0;
   end
end


always @(posedge clk) begin
   if(!rst && ready && !local_busy && ram_addr_in)begin
 /*
      if (rd) begin
         busy <= 1'b1;
         case (size_out)
            2'b00:begin
               local_data_out <= {24'b0, memory[addr_out][ 8:0]};
            end
            2'b01: begin
               local_data_out <= {16'b0, memory[addr_out][15:0]};
            end
            2'b10: begin
               local_data_out <= memory[addr_out]; 
            end
         endcase
      end
 */
      if(wd) begin
         local_busy <= 1'b1;
         case (size_in)
            2'b10: // 32bits
               memory[addr_in] <= data_in;
            2'b01: // 16bits
               memory[addr_in] <= {memory[addr_in][31:16],data_in[15:0]};
            2'b00: // 8bits
               memory[addr_in] <= {memory[addr_in][31:8],data_in[7:0]};
         endcase
         $display("Memoria in 0h%08h <= 0h%08h", addr_in, memory[addr_in]);
      end
   end

end
endmodule
