`include "MemoryMap.vh"

module DataBusControl (
   input      rst,
   input      clk, wd, rd, 
   output reg ready, 
   output reg busy,

   input      [1:0]            size_in, size_out,
   
   input      [31:0]           addr_in, addr_out,
   
   input      [31:0]           data_in, 
   output     [31:0]           data_out
`ifdef RISCUIN_DUMP
   ,input dump
`endif
);


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

wire [`DBC_RAM_ADDR_WIDTH-1:0] local_ram_addr_out = ram_addr_out ? 
                                                    addr_out[`DBC_RAM_ADDR_WIDTH-1:0]: 
                                                    {`DBC_RAM_ADDR_WIDTH{1'bz}}; 
wire [`DBC_RAM_ADDR_WIDTH-1:0] local_ram_addr_in  = ram_addr_out ?
                                                    addr_in[`DBC_RAM_ADDR_WIDTH-1:0] :
                                                    {`DBC_RAM_ADDR_WIDTH{1'bz}};
 
wire dbc_register_addrs = (addr_out >= `DBC_REGISTER_START) && (addr_out <= `DBC_REGISTER_END);

assign local_data_out = (!rst && ready && !busy && ram_addr_out && rd)  ?
                        size_out == 2'b00 ? {24'b0, memory[local_ram_addr_out][ 7:0]} :
                        size_out == 2'b01 ? {16'b0, memory[local_ram_addr_out][15:0]} :
                        size_out == 2'b10 ? memory[local_ram_addr_out] : 32'b0 : 
                        32'b0;

assign data_out = dbc_register_addrs                                    ? // endereços dos registradores dbc
                  
                  (addr_out == `DBC_REGISTER_MISALIGNED_EXCEPTION_ADDR || // registrador desalinhamento
                   addr_out == `DBC_REGISTER_EMPTY_ADDR_EXCPETION_ADDR) ?  // registrador endereço vazio/invalido
                   dbc_register[31:0]                                   : 
                  
                   32'b1                                   :  // default para registradores dbc 

                  local_data_out                                       ;  // outro dado endereçado

always @(posedge clk ) begin
   dbc_register[`DBC_REGISTER_EMPTY_ADDR_EXCEPTION_START_BIT] <=
                                 !ram_addr_out & !ram_addr_in  &
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
   local_rst  <= 1'bx;
   busy       <= 1'bx;
   local_busy <= 1'bx;
   ready      <= 1'b1;
end

always @(*) begin
// busy não é usado exernamente ainda.
//     busy <= local_busy;
   busy <= 1'b0;
   dbc_register[`DBC_REGISTER_BUS_BUSY_START_BIT] <= local_busy;
end

always @(posedge clk) begin

   if(rd) begin
      $display("Memoria out 0h%08h => 0h%08h", addr_out, memory[local_ram_addr_out]);
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

    memory_tmp_in  <= memory[local_ram_addr_in];  // port 1

   if(!rst && ready && !local_busy && ram_addr_in)begin
      if(wd) begin
         //local_busy <= 1'b1;
         
         memory[local_ram_addr_in] <= size_in == 2 ? data_in :
                                      size_in == 1 ? {memory_tmp_in[31:16],data_in[15:0]} :
                                      size_in == 0 ? {memory_tmp_in[31:8],data_in[7:0]} :
                                                     memory_tmp_in;
/*       case (size_in)
            2'b10: // 32bits
               memory[local_ram_addr_in] <= data_in;
            2'b01: // 16bits
               memory[local_ram_addr_in] <= {memory_tmp_in[31:16],data_in[15:0]};
            2'b00: // 8bits
               memory[local_ram_addr_in] <= {memory_tmp_in[31:8],data_in[7:0]};
         endcase */
         $display("Memoria in 0h%08h <= 0h%08h", local_ram_addr_in, memory_tmp_in);
      end
   end

end

`ifdef RISCUIN_DUMP
   integer i;
   integer fileDesc;
   always @(posedge clk) begin
      if(dump) begin
         $display("DataBusControl: Arquivo Dump: %s, %10t", `RISCUIN_DUMP_FILE_DBC, $realtime);
         fileDesc = $fopen({"./dumps/",`RISCUIN_DUMP_FILE_DBC},"a");
         $fwrite(fileDesc,"Dump Data Bus Control inicializado em:  %10t\n",$realtime);
         $fwrite(fileDesc,"rst: %0b, wd: %0b, rd: %0b, ready: %0b, busy: %0b \n",rst, wd, rd, ready, busy);
         $fwrite(fileDesc,"Addr in: %8h, Size: %4h, Data: %8h\n",addr_in,size_in,data_in);
         $fwrite(fileDesc,"Addr out: %8h, Size: %4h, Data: %8h\n",addr_out,size_out,data_out);
         $fwrite(fileDesc,"========================================================= \n");
         $fwrite(fileDesc,"           0x00       0x01     0x02     0x03     0x04     0x05     0x06     0x07  \n");
         for (i=0; i<`DBC_RAM_SIZE; i=i+8) begin:dump_memory
            $fwrite(fileDesc,"0x%8h - %8h %8h %8h %8h %8h %8h %8h %8h \n", i,
              memory[i+0], memory[i+1], memory[i+2], memory[i+3], 
              memory[i+4], memory[i+5], memory[i+6], memory[i+7]);
         end 
         $fwrite(fileDesc,"Dump finalizado em:  %10t\n",$realtime);
         $fwrite(fileDesc,"#########################################################\n");
         $fclose(fileDesc);
      end
    end
`endif
endmodule
