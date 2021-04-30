`include "./config.vh"
`include "./MemoryMap.vh"

module RISCuin(
   input clk, rst, 
   output pc_end,
   inout [`GPIO_WIDTH-1:0] gpio
);

wire /*rb_ready,*/ alu_sel, bus_w, bus_r, bus_busy, unsigned_value;
wire [1:0]  bus_size;

wire local_rst = rst /*| ~rb_ready*/;

wire branch, load_pc;

wire reg_w;
wire [4:0] rd_sel, rs1_sel, rs2_sel;
wire [1:0] rd_data_sel;

wire [31:0] rs1_data, rs2_data, alu_out;
wire [31:0] data_in, data_out, data_eei;
wire [31:0] imm;

wire [4:0] alu_opcode;

wire imm_rs2_sel;

wire [`INSTR_ADDR_WIDTH-1:0] pc, pc_plus, pc_next;
wire [`INSTR_ADDR_WIDTH-1:0] pc_branch =  alu_out[`INSTR_ADDR_WIDTH-1:2];
wire [`INSTR_ADDR_WIDTH+1:0] pc_ext = {pc,2'b00};
wire pc_enable = !rst /*&& rb_ready&*/ && !pc_end && !bus_busy;

//reg pgm;
wire [31:0] instr;

/*
initial begin
   pgm <= 1'b0;
   //$monitor("Program Counter: %h",pc_ext);
end
*/

wire [31:0] alu_A       = branch || load_pc ? {pc,2'b0}  : rs1_data;
wire [31:0] alu_B       = imm_rs2_sel       ? imm        : rs2_data;

`include "IntegerBasicALU_OPCode.vh"
wire do_branch =  branch ?
                     alu_opcode == `B_EQ    ?         rs1_data  ==         rs2_data :
                     alu_opcode == `B_NE    ?         rs1_data  !=         rs2_data :
                     alu_opcode == `B_LT    ? $signed(rs1_data) <  $signed(rs2_data) :
                     alu_opcode == `B_GE    ? $signed(rs1_data) >  $signed(rs2_data) :
                     alu_opcode == `B_LTU   ?         rs1_data  <          rs2_data :
                     alu_opcode == `B_GEU   ?         rs1_data  >          rs2_data :
                                                         1'b0:
                                                         load_pc;
//   00 -> alu
//   01 -> bus (data_eei é o dado processado do barramento)
//   10 -> imm
//   11 -> pc + 4
wire [31:0] rd_data     = rd_data_sel == 2'b00 ? alu_out : 
                          rd_data_sel == 2'b01 ? data_eei: 
                          rd_data_sel == 2'b10 ? imm: 
                          rd_data_sel == 2'b11 ? {pc_plus,2'b0}: 
                                                 32'bx;
// Gerenciamento de acesso a memória de dados
// as exceptions abaixo serão usadas futuramente
// wire address-misaligned, access-fault;

assign data_in = rs2_data;


/*#########
 Determina se o dado deve ser extendido com ou sem sinal
 */
assign data_eei = !unsigned_value    ? 
                  bus_size == 2'b00 ? {{24{data_out[ 7]}},data_out[ 7:0]} :
                  bus_size == 2'b01 ? {{16{data_out[15]}},data_out[15:0]} :
                  data_out:data_out;


/* #########
   Unidade que controla o contador de programa.
   
   É importante ignorar os dos bytes menos significativos.

   E        -> Habilita a contagem
   pc_src   -> Seleciona a origem do pc, pc_plus ou branch_addr
   pc       -> Address fornecido pelo Program Counter 
   pc_next -> próximo pc que será fornecido (pc_plus ou branch_addr)
   pc_plus -> pc atual mais o passo
   branch_addr -> endereço para salto 
 */
ProgramCountControlUnit #(.INSTR_ADDR_WIDTH(`INSTR_ADDR_WIDTH)) 
                     pccu(.clk(clk), .rst(local_rst), .E(pc_enable), 
                          .pc_src(do_branch), 
                          .pc(pc), .pc_plus(pc_plus), .pc_branch(pc_branch), .pc_next(pc_next),
                          .pc_end(pc_end)
                         );

/* #########
   Memória de programa
   Este core usa Arquitetura Havard
 */
ProgramMemory #(.INSTR_ADDR_WIDTH(`INSTR_ADDR_WIDTH)) 
                     prog_m(.clk(clk), 
                            .pc(pc), .instr(instr));

/* ########
   Decodificador de instruções RV32I básico.
 */
InstructionDecoderRV32I idRV32I(.instr(instr), .alu_opcode(alu_opcode), 
                        .alu_sel(alu_sel), .branch(branch), .load_pc(load_pc),
                        .rs1_sel(rs1_sel), .rs2_sel(rs2_sel), .rd_sel(rd_sel), 
                        .rd_data_sel(rd_data_sel),
                        .reg_w(reg_w),
                        .imm_rs2_sel(imm_rs2_sel),
                        .imm(imm),
                        .data_w(bus_w), .data_r(bus_r),
                        .data_size(bus_size), .unsigned_value(unsigned_value)
                     );
/* #######
   Banco de Registradores
 */                     
RegisterBank rb(.clk(clk), .rst(rst), /*.ready(rb_ready),*/ 
                  .rs1_sel(rs1_sel), .rs2_sel(rs2_sel), .rd_sel(rd_sel), .reg_w(reg_w),
                  .rs1_data(rs1_data), .rs2_data(rs2_data), .rd_data(rd_data));


/* ###########
   Unidade Lógica Aritimética para Inteiros, Unidade Básica do RV32I
 */
IntegerBasicALU #(.DATA_WIDTH(`INTERNAL_DATA_WIDTH)) ib_alu(
   .E(alu_sel && !local_rst),
   .alu_op(alu_opcode),
   .A(alu_A), .B(alu_B),
   .out(alu_out)
);

/* ########
   Barramento de Dados e Dispositivos de Entrada e Saida de propósito geral
   O DataBusControl é responsável por gerenciar o acesso a memória de dados 
   e a dispositivos externos,
   Mesmo qe estejam hieraquicamente acima acima do módulo RISCuinho, 
   já que é ele que verifica se é permitido o acesso ao endereço socilitado, 
   emitindo uma exeção e gravando nos registradores de estados proprietários 
   criados por mim.
 */
DataBusControl data_m_ctl(
                        .rst(local_rst),
                        .clk(clk), 
                        .wd(bus_w), .rd(bus_r),
                        .size(bus_size),
                        .addr(alu_out),
                        .data_in(data_in), .data_out(data_out),
                        .gpio(gpio)
);


/* ########
   SYNCH
   CONTROL
   SYSTEM
 */
`ifdef RISCUIN_ControlSistemOperation
wire cso_e = 1'b1;
ControlSistemOperation cso(
   E(cso_e),
   instr(instr),
   .rd_sel(rd_sel), .rs1_sel(.rs1_sel),
   .rd_data(rd_data), .rs1_data(.rs1_data)
);
`endif 


/* ###############
   Apoio ao IVerilog  
 */
`ifdef __ICARUS__
IVerilogInstructionTable iverilog_it(
                        .rst(local_rst),
                        .clk(clk),
                        .instr(instr), .full_alu_opcode(alu_opcode), 
                        .rs1_sel(rs1_sel), .rs2_sel(rs2_sel), .rd_sel(rd_sel), 
                        .rd_data_sel(rd_data_sel),
                        .rs1_data(rs1_data), .rs2_data(rs2_data), .rd_data(rd_data),
                        .imm(imm)
                        );
`endif
endmodule
