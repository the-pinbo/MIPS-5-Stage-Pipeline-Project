// `include "M_MemSync.v"

module M_PiplineStage4MEM #(
    parameter N=32,
    N_REG = 256
)(
    // control signals
    input clk,
    input reset,
    input branch,
    input mem_read,
    input mem_write, 
    
    // branch address
    input[N-1:0] branch_addr,
    // zero flag
    input zero,
    // ALU result
    input[N-1:0] alu_out,
    // write register
    input[$clog2(N)-1:0] write_reg,
    // write data
    input[N-1:0] write_data,
    
    // select branch | ~(pc+1)
    output pc_sel_mem,
    // Pipline registers for WB stage
    output reg[N-1:0] read_data_mem,
    output reg[N-1:0] alu_out_mem,
    output reg [$clog2(N)-1:0] write_reg_mem,

    // Saved control signals
    // WB
    input mem_to_reg_mem,
    output reg mem_to_reg_wb,
    input reg_write_mem,
    output reg reg_write_wb

);
    assign pc_sel_mem = zero&branch;
    wire[N-1:0] read_data;
    M_MemSync DataMemory(
        .clk(clk),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .address(alu_out[$clog2(N_REG)-1:0]),
        .write_data(write_data),
        .read_data(read_data)
    );
    
    // Saving the states in the pipline registers
    always@(posedge clk) begin
        alu_out_mem <= alu_out;
        write_reg_mem <= write_reg;
        read_data_mem <= read_data;

        // Saving the control signals
        mem_to_reg_wb <= mem_to_reg_mem;
        reg_write_wb <= reg_write_mem;
    end
    
endmodule