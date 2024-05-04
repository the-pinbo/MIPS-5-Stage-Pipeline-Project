module M_Registers #(
    parameter N = 32,
    N_REG = 32
) (
    input clk,
    input reg_write,
    input[$clog2(N_REG)-1:0] read_reg1,
    input[$clog2(N_REG)-1:0] read_reg2,
    input[$clog2(N_REG)-1:0] write_reg,
    input[N-1:0] write_data,
    output[N-1:0] read_data1,
    output[N-1:0] read_data2
);
    reg[N-1:0] Register [N_REG-1:0];

    // Double Pumped Reg file
    assign read_data1 = read_reg1?Register[read_reg1]:0;
    assign read_data2 = read_reg2?Register[read_reg2]:0;
    
    always@(negedge clk)begin
        if(reg_write)begin
            Register[write_reg] <= write_data;
        end
    end
endmodule