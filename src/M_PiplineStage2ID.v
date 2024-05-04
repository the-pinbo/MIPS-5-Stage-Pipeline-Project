// `include "M_Registers.v"
// `include "M_Mux.v"
// `include "M_SExt.v"

module M_PiplineStage2ID #(
    parameter N=32,
    N_REG = 32,
    READ_REG1_IDX = 25, 
    READ_REG2_IDX = 20, 
    WRITE_REG_IDX = 20,
    RT_IDX = 20,
    RD_IDX = 15,
    IMM_16 = 16,
    N_ALU_OP = 2
)(
    input clk,
    input reset,

    input[N-1:0] instruction,
    
    // PC
    input[N-1:0] pc_in,
    output reg[N-1:0] pc_out,

    // Write back stage data
    input reg_write_wb,
    input[$clog2(N_REG)-1:0] write_reg_wb,
    input[N-1:0] write_data_wb,
    
    // read data 1
    output reg[N-1:0] read_data_1,
    // read data 2
    output reg[N-1:0] read_data_2,
    // 16 bit immediate
    output reg[N-1:0] sext_imm_16,
    // write back register Rs
    output reg[$clog2(N_REG)-1:0] rs,
    // write back register Rt
    output reg[$clog2(N_REG)-1:0] rt,
    // write back register Rd
    output reg[$clog2(N_REG)-1:0] rd,
    
    // EX
    input alu_src,
    output reg alu_src_ex,
    input[N_ALU_OP-1:0] alu_op,
    output reg[N_ALU_OP-1:0] alu_op_ex,
    input reg_dest,
    output reg reg_dest_ex,

    // MEM
    input branch,
    output reg branch_ex,
    input mem_read,
    output reg mem_read_ex,
    input mem_write,
    output reg mem_write_ex,

    // WB
    input mem_to_reg,
    output reg mem_to_reg_ex,
    input reg_write,
    output reg reg_write_ex
);

    // Register file 
    wire[N-1:0] rf_out_rd_data_1, rf_out_rd_data_2;
    M_Registers #(.N(N), .N_REG(N_REG))RegFile(
        .clk(clk),
        .reg_write(reg_write_wb),
        .read_reg1(instruction[READ_REG1_IDX:READ_REG1_IDX-$clog2(N_REG)+1]),
        .read_reg2(instruction[READ_REG2_IDX:READ_REG2_IDX-$clog2(N_REG)+1]),
        .write_reg(write_reg_wb),
        .write_data(write_data_wb),
        .read_data1(rf_out_rd_data_1),
        .read_data2(rf_out_rd_data_2)
    );

    // signextend 16 bit immediate
    wire[N-1:0] sext_out_imm_16;
    M_SExt #(.N(N), .IMM_N(IMM_16)) SExt_16(
        .immediate(instruction[IMM_16-1:0]),
        .sext_out(sext_out_imm_16)
    );

    // Saving the states in the pipline registers
    always@(posedge clk) begin
        // program counter
        pc_out <= pc_in;
        // read data 1
        read_data_1 <= rf_out_rd_data_1;
        // read data 2
        read_data_2 <= rf_out_rd_data_2;
        // 16 bit immediate
        sext_imm_16 <= sext_out_imm_16;
        // write back register Rs
        rs <= instruction[READ_REG1_IDX:READ_REG1_IDX-$clog2(N_REG)+1];
        // write back register Rt
        rt <= instruction[RT_IDX:RT_IDX-$clog2(N_REG)+1];
        // write back register Rd
        rd <= instruction[RD_IDX:RD_IDX-$clog2(N_REG)+1];

        // Save the control signals

        // EX
        alu_src_ex <= alu_src;
        alu_op_ex <= alu_op;
        reg_dest_ex <= reg_dest;

        // MEM
        branch_ex <= branch;
        mem_read_ex <= mem_read; 
        mem_write_ex <= mem_write;

        // WB
        mem_to_reg_ex <= mem_to_reg;
        reg_write_ex <= reg_write;
    end
    
endmodule