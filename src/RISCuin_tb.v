`include "./config.vh"

`ifdef __ICARUS__
`timescale 10ns/1ns
`endif
`ifndef RISCUIN_TB
`define RISCUIN_TB 1
`endif
module RISCuin_tb;



   wire start_rst, finish_rst, internal_rst;
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
      #00000 $display("RISCuinho Testbentch: Iniciado!");
`ifdef __ICARUS__
      $display("RISCuin_tb: Icarus ativo");
`endif
`ifdef __IOSYS__
      $display("RISCuin_tb: IOSYS ativo");
`endif
`ifdef RISCUIN_DUMP
      $display("RISCuin_tb: Dump está ativo, será criado dump de memória e registradores");
`endif
      
      $dumpfile("RISCuin.vcd");
      $dumpvars;

      #02000 $display("RISCuinho Testbentch: 2000 Ticks será finalziado!");
      `ifndef __YOSYS__
      $finish;
      `endif
    end

   wire  pc_end;
   reg   halt = 1'b0;
`ifndef __YOSYS__
   always @(posedge pc_end or posedge internal_rst or posedge finish_rst)
      halt <= (pc_end || internal_rst || finish_rst );

   integer count_halt_clock = `RISCUIN_CLOCK_WAIT_FINISH;
   always @(posedge clk)
      if(halt)begin
         if(count_halt_clock) count_halt_clock <= count_halt_clock - 1;
         else $finish;
      end
`endif 

   
`ifdef RISCUIN_DUMP
// dump sinaliza que deve ser feito o dump geral
   wor local_dump;
   reg dump = 1'b0;
// o PC aqui é usado para contabilizar quantos endereços 
// de instruções foram exectuados
   wire  [`INSTR_ADDR_WIDTH-1:0] pc;
// futuramente irei contabilizar por instrução e não 
// pelo PC, o pc vária positivamente e negativamente,
// já a contagem de instrução valida é sempre continua.
//######
// usarei o AutoReset para gerar o sinal de dump com base
// no clock, o AutoReset será ajustado para atender melhor
// também esta demanda
    AutoReset #(.INVERT_RST(1'b1))aDump 
               (.clk(clk), .count(`RISCUIN_DUMP_COUNT_CLOCK), .rst(local_dump));
// bloco que monitora a contagem do pc
   assign local_dump = pc == `RISCUIN_DUMP_COUNT_PC;
   assign local_dump = pc_end == `RISCUIN_DUMP_PC_END;
   reg last_dump = 1'b0;
   always @(posedge clk) 
      if(local_dump && !last_dump) begin 
         dump <= 1'b1;
         last_dump <= 1'b1;
      end
   always @(posedge clk) 
      if(dump) dump <= 1'b0;
`endif
   
   AutoReset aRst(.clk(clk), .count(`RISCUIN_WATCHDOG_START), .rst(start_rst)); 
   AutoReset aRstFinish(.clk(clk && !start_rst), .count(`RISCUIN_WATCHDOG_RST), .rst(finish_rst)); 
   RISCuin cpu(.clk(clk), .rst(start_rst|| !finish_rst), .pc_end(pc_end), .internal_rst(internal_rst)
`ifdef RISCUIN_DUMP
      , .pc(pc)
      , .dump(dump)
`endif
   );

endmodule
