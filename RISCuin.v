`ifdef __ICARUS__
`define SIMULATOR 1
`elsif __YOSYS__
`define SIMULATOR 1
`else 
`define DATA_MEMORY_WIDTH 10
`endif 

`ifdef SIMULATOR
`define MEM_DATA_ADDR_WIDTH 10
`define MEM_DATA_WIDTH 32
`define INTERNAL_DATA_WIDTH 32 
`define INSTR_ADDR_WIDTH 5
`else
`define MEM_DATA_ADDR_WIDTH 10
`define MEM_DATA_WIDTH 32
`define INTERNAL_DATA_WIDTH 32 
`define INSTR_ADDR_WIDTH 5
`endif

module RISCuin(
   input clk, rst, 
   output pc_end);

wire rb_ready, alu_sel, mem_ready, mem_w, mem_r, unsigned_value;

wire [1:0] mem_size;

wire local_rst = rst | ~rb_ready;

wire [`INSTR_ADDR_WIDTH-1:0] pc, pc_plus, pc_next;
wire [`INSTR_ADDR_WIDTH-1:0] pc_branch =  alu_out[`INSTR_ADDR_WIDTH-1:0];
wire [`INSTR_ADDR_WIDTH+1:0] pc_ext = {pc,2'b00};
wire pc_enable = !rst && mem_ready && rb_ready && !pc_end;

wire branch;

reg pgm;
wire [31:0] instr;

initial begin
   pgm <= 1'b0;
   //$monitor("Program Counter: %h",pc_ext);
end

wire reg_w;
wire [4:0] rd_sel, rs1_sel, rs2_sel;
wire [1:0] rd_data_sel;
wire [31:0] rs1_data, rs2_data, alu_out;

wire [1:0]  to_size, from_size;

wire [15:0] alu_op;

wire imm_rs2_sel;
wire [31:0] imm;

wire [31:0] alu_A       = branch ? pc : rs1_data;
wire [31:0] alu_B       = imm_rs2_sel ? imm : rs2_data;

//   00 -> alu
//   01 -> bus
//   10 -> imm
//   11 -> pc + 4
wire [31:0] rd_data     = rd_data_sel == 2'b00 ? alu_out : 
                          rd_data_sel == 2'b01 ? data_out: 
                          rd_data_sel == 2'b10 ? imm: 
                          rd_data_sel == 2'b11 ? pc_plus: 
                                                 32'bx;

wire [`MEM_DATA_ADDR_WIDTH-1:0] data_addr_in = alu_out[`MEM_DATA_ADDR_WIDTH-1:0];
wire [`MEM_DATA_ADDR_WIDTH-1:0] data_addr_out = alu_out[`MEM_DATA_ADDR_WIDTH-1:0];
wire [`MEM_DATA_WIDTH-1     :0] data_in, data_out;

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
                          .pc_src(branch), 
                          .pc(pc), .pc_plus(pc_plus), .pc_branch(pc_branch), .pc_next(pc_next),
                          .pc_end(pc_end)
                         );
/* #########
   Memória de programa
   Este core usa Arquitetura Havard
 */
ProgramMemory #(.INSTR_ADDR_WIDTH(`INSTR_ADDR_WIDTH)) 
                     prog_m(.clk(clk), 
                            .pc(pc), .pgm(pgm), .instr(instr));

/* ########
   Decodificador de instruções RV32I básico.
 */
IntegerBasicInstructionDecoder ib_id(.instr(instr), .full_op_code(alu_op), 
                        .alu_sel(alu_sel), .jump(branch),
                        .rs1_sel(rs1_sel), .rs2_sel(rs2_sel), .rd_sel(rd_sel), 
                        .rd_data_sel(rd_data_sel),
                        .reg_w(reg_w),
                        .imm_rs2_sel(imm_rs2_sel),
                        .imm(imm),
                        .mem_w(mem_w), .mem_r(mem_r),
                        .mem_size(mem_size), .unsigned_value(unsigned_value)
                     );
/* #######
   Banco de Registradores
 */                     
RegisterBank rb(.clk(clk), .rst(rst), .ready(rb_ready), 
                  .rs1_sel(rs1_sel), .rs2_sel(rs2_sel), .rd_sel(rd_sel), .reg_w(reg_w),
                  .rs1_data(rs1_data), .rs2_data(rs2_data), .rd_data(rd_data));


/* ###########
   Unidade Lógica Aritimética para Inteiros, Unidade Básica do RV32I
 */
IntegerBasicALU #(.DATA_WIDTH(`INTERNAL_DATA_WIDTH)) ib_alu(
   .E(alu_sel),
   .alu_op(alu_op),
   .A(alu_A), .B(alu_B),
   .out(alu_out),
   .branch(branch)
);

/* ########
   Barramento de Dados e Dispositivos de Entrada e Saida de propósito geral
 */
DataBusControl #(.ADDR_WIDTH(`MEM_DATA_ADDR_WIDTH), .DATA_WIDTH(`MEM_DATA_WIDTH)) 
                     data_m_ctl(.clk(clk), 
                           .ready(mem_ready),
                           .wd(mem_w), .rd(mem_r),
                           .to_size(mem_size), .from_size(mem_size),
                           .unsigned_value(unsigned_value), 
                           .addr_in(addr_in), .addr_out(addr_out),
                           .data_in(data_in), .data_out(data_out));


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
                        .instr(instr), .full_op_code(alu_op), 
                        .rs1_sel(rs1_sel), .rs2_sel(rs2_sel), .rd_sel(rd_sel), 
                        .rd_data_sel(rd_data_sel),
                        .rs1_data(rs1_data), .rs2_data(rs2_data), .rd_data(rd_data),
                        .imm(imm)
                        );
`endif
endmodule
