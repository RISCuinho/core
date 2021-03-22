module ProgramMemory #(
   parameter INSTR_ADDR_WIDTH   = 20,
   parameter STEP    = 4
) (
   input                                  clk,
   input       [INSTR_ADDR_WIDTH-1:0]     pc,
   output reg  [(STEP*8)-1:0]             instr,
   // a memória pode ser grava em circunstãncias especiais
   input                                  pgm,
   input       [INSTR_ADDR_WIDTH-1:0]     addr,
   input       [(STEP*8)-1:0]             data
);
   localparam SIZE = 2**INSTR_ADDR_WIDTH;
   /* 
    * A memória será acesada em grupos de bytes (step), 
    * assim o ponteiro poderá ser incrementado conforme 
    * este grupo e reduzir o tamanho do barramento.
    */
   reg [(STEP*8)-1:0] memory [0:SIZE-1]; 
   
   
   initial begin
      $display("Program Memory step %0d, memory word %0d bits, address width %0d bits, total words %0d", 
                                                                           STEP, (STEP*8), INSTR_ADDR_WIDTH, SIZE);
      $display("Load prog_%0d.hex",SIZE);
      if(INSTR_ADDR_WIDTH == 5 )
         $readmemh("./prog_32.hex", memory); // carrega um programa de referência   
      else if(INSTR_ADDR_WIDTH == 6 )
         $readmemh("./prog_64.hex", memory); // carrega um programa de referência   
      else if(INSTR_ADDR_WIDTH == 7 )
         $readmemh("./prog_128.hex", memory); // carrega um programa de referência   
      else if(INSTR_ADDR_WIDTH == 8 )
         $readmemh("./prog_254.hex", memory); // carrega um programa de referência   
   end

   always @(posedge clk) begin
      instr <= memory[pc];  
      if(pgm) memory[addr] <= data;
   end

endmodule
