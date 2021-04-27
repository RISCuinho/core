module IntegerBasicALU #(
   parameter DATA_WIDTH = 32
)(
   input         E,
   input         [4:0] alu_op,
   input  signed [DATA_WIDTH-1:0] A, B,
   output signed [DATA_WIDTH-1:0] out
);

`include "IntegerBasicALU_OPCode.vh"

assign out = !E               ? {DATA_WIDTH{1'b0}}  :
             alu_op == `ALU_ADD     ? $signed(A) + $signed(B) :

             alu_op == `ALU_SUB    ? $signed(A) - $signed(B) :  

             alu_op == `ALU_SLL    ? $signed(A) << $signed(B) :  

             alu_op == `ALU_SRL    ? $signed(A) >> $signed(B) :  

             alu_op == `ALU_SRA    ? $signed($signed(A) >>> B) :

             alu_op == `ALU_LTU    ?  A < B                  :

             alu_op == `ALU_LTS    ? $signed(A) < $signed(B) :

             alu_op == `ALU_AND    ? A & B                  :

             alu_op == `ALU_OR     ? A | B                  :

             alu_op == `ALU_XOR    ? A ^ B                  :

                               {DATA_WIDTH{1'b0}}; 


endmodule
