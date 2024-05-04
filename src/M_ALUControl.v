module M_ALUControl #(
    parameter N = 32,
    N_FN_FIELD = 6,
    N_ALU_CTRL = 4,
    N_ALU_OP = 2 
) (
    input[N_ALU_OP-1:0] alu_op,
    input[N_FN_FIELD-1:0] fn_field,
    output reg[N_ALU_CTRL-1:0] alu_ctrl
);
    always@(alu_op or fn_field)begin
        casex({alu_op,fn_field})
            8'b00_xxxxxx:alu_ctrl=4'b0010; //lw / sw
            8'b01_xxxxxx:alu_ctrl=4'b0110; //beq
            8'b1x_xx0000:alu_ctrl=4'b0010; //add
            8'b1x_xx0010:alu_ctrl=4'b0110; //sub
            8'b1x_xx0100:alu_ctrl=4'b0000; //and
            8'b1x_xx0101:alu_ctrl=4'b0001; //or
            8'b1x_xx1010:alu_ctrl=4'b0111; //slt
        endcase
    end
endmodule


