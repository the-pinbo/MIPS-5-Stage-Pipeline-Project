module M_PiplineALU #(
    parameter N = 32,
    N_ALU_CTRL = 4
) (
    input[N-1:0] op_a, op_b,
    input[N_ALU_CTRL-1:0] alu_ctrl,
    output zero,
    output reg[N-1:0] result
);
    assign zero = (result==0);

    always @(alu_ctrl, op_a, op_b) begin
        
        case (alu_ctrl)
            4'b0000: result = op_a&op_b;
            4'b0001: result = op_a|op_b;
            4'b0010: result = op_a+op_b;
            4'b0110: result = op_a-op_b;
            4'b0111: result = op_a<op_b?1:0; //slt
            4'b1100: result = ~(op_a|op_b);
        endcase

    end
    
endmodule