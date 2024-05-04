// `include "M_Mux.v"

module M_PiplineStage5WB #(
    parameter N=32,
    N_REG = 256
)(
    // control signals
    input clk,
    input reset,
    // WB stage write data from ALU or Memory
    input mem_to_reg,
    input[N-1:0] read_data,
    input[N-1:0] alu_out,
    output[N-1:0] write_data_wb,
    // WB stage register write 
    input reg_write,
    output reg_write_wb,
    // WB stage write register
    input [$clog2(N_REG)-1:0] write_reg,
    output[$clog2(N_REG)-1:0] write_reg_wb
);

    M_Mux #(.DATA_N(N)) DataMux (
        .in_a(alu_out),
        .in_b(read_data),
        .sel(mem_to_reg),
        .out(write_data_wb)
    );

    assign write_reg_wb = write_reg;
    assign reg_write_wb = reg_write;
    
endmodule