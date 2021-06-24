`include "IntegerBasicALU_OpCodes.vh"

module IntegerBasicALU #(
   parameter DATA_WIDTH = 32
)(
   input                          E,
   input         [ 5:0]           alu_op,
   input  signed [DATA_WIDTH-1:0] A, B,
   output signed [DATA_WIDTH-1:0] out,
   output                         carriage 
);

wire [DATA_WIDTH-1:0] left,right,arith; 

assign {carrige,left}  = alu_op == `ALU_OP_SHIFT_LEFT    ? $signed(A)         << $signed(B) : {DATA_WIDTH + 1{1'b0}};        
assign {right,carrige} = alu_op == `ALU_OP_SHIFT_RIGHT   ? $signed(A)         >> $signed(B) : 
                         alu_op == `ALU_OP_SHIFT_RIGHT_A ? $signed($signed(A) >>> B) :        {DATA_WIDTH + 1{1'b0}};        

assign {carrige,arith} = alu_op == `ALU_OP_PLUS          ? $signed(A) + $signed(B)   :
                         alu_op == `ALU_OP_SUB           ? $signed(A) - $signed(B)   :        {DATA_WIDTH + 1{1'b0}};        

assign out = !E                                 ? {DATA_WIDTH{1'b0}}        :
               
             alu_op == `ALU_OP_PLUS || `ALU_OP_SUB ? arith :  

             alu_op == `ALU_OP_SHIFT_LEFT       ? left   :  
             alu_op == `ALU_OP_SHIFT_RIGHT || `ALU_OP_SHIFT_RIGHT_A    ? right  :

             alu_op == `ALU_OP_SET_LESS_THAN_U ?  A < B                    :

             alu_op == `ALU_OP_SET_LESS_THAN   ? $signed(A) < $signed(B)   :

             alu_op == `ALU_OP_AND             ? A & B                     :

             alu_op == `ALU_OP_OR              ? A | B                     :

             alu_op == `ALU_OP_XOR             ? A ^ B                  :

                               {DATA_WIDTH{1'b0}}; 


endmodule
