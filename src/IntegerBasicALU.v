`include "IntegerBasicALU_OpCodes.vh"

module IntegerBasicALU #(
   parameter DATA_WIDTH = 32
)(
   input                          E,
   input         [ 5:0]           alu_op,
   input  signed [DATA_WIDTH-1:0] A, B,
   output signed [DATA_WIDTH-1:0] out,
   output                         carry
);

assign {left,out,right} = !E                   ? {DATA_WIDTH+2{1'b0}}             :
               
             alu_op == `ALU_OP_PLUS            ? {{1'b0,$signed(A)} + $signed(B),1'b0}   :
             alu_op == `ALU_OP_SUB             ? {{1'b0,$signed(A)} - $signed(B),1'b0}   :

             alu_op == `ALU_OP_SHIFT_LEFT      ? {{1'b0,$signed(A)} << $signed(B),1'b0}  :         

             alu_op == `ALU_OP_SHIFT_RIGHT     ? {1'b0,{        $signed(A),1'b0} >>  $signed(B)}  : 
             alu_op == `ALU_OP_SHIFT_RIGHT_A   ? {1'b0,$signed({$signed(A),1'b0} >>> B)}          :

             alu_op == `ALU_OP_SET_LESS_THAN_U ? {1'b0,A < B,1'b0}                    :

             alu_op == `ALU_OP_SET_LESS_THAN   ? {1'b0,$signed(A) < $signed(B),1'b0} :

             alu_op == `ALU_OP_AND             ? {1'b0,A & B,1'b0}                     :

             alu_op == `ALU_OP_OR              ? {1'b0,A | B,1'b0}                     :

             alu_op == `ALU_OP_XOR             ? {1'b0,A ^ B,1'b0}                  :

                               {DATA_WIDTH+2{1'b0}}; 

assign carry = alu_op == `ALU_OP_PLUS          ||
               alu_op == `ALU_OP_SUB           ||
               alu_op == `ALU_OP_SHIFT_LEFT     ? left :
               alu_op == `ALU_OP_SHIFT_RIGHT   ||
               alu_op == `ALU_OP_SHIFT_RIGHT_A  ? right :
               1'b0;

endmodule
