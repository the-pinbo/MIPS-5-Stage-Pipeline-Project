// `include "M_PiplineDatapath.v"
// `include "M_Controller.v"
// 'include "M_Mux.v"


module PiplineMIPS #(
    parameter N = 32,
    N_REG = 32,
    N_OPCODE = 6,
    N_ALU_OP = 2,
    READ_REG1_IDX = 25,
    READ_REG2_IDX = 20,
    WRITE_REG_IDX = 20,
    RT_IDX = 20,
    RD_IDX = 15,
    IMM_16 = 16
) (
    input clk,
    input reset
);
    // opcode to the controller
    wire[N_OPCODE-1:0] opcode;
    // EX
    wire alu_src;
    wire[N_ALU_OP-1:0] alu_op, alu_op_d;
    wire reg_dest;
    // MEM
    wire branch;
    wire mem_read;
    wire mem_write;
    // WB
    wire mem_to_reg;
    wire reg_write;

    M_PiplineDatapath  #(
    .N(N),
    .N_REG(N_REG),
    .N_OPCODE(N_OPCODE),
    .READ_REG1_IDX(READ_REG1_IDX),
    .READ_REG2_IDX(READ_REG2_IDX),
    .WRITE_REG_IDX(WRITE_REG_IDX),
    .RT_IDX(RT_IDX),
    .RD_IDX(RD_IDX),
    .IMM_16(IMM_16),
    .N_ALU_OP(N_ALU_OP)
    ) DataPath(
        .clk(clk),
        .reset(reset),
        .opcode(opcode),
        .alu_src(alu_src_d),
        .alu_op(alu_op_d),
        .reg_dest(reg_dest_d),
        .branch(branch_d),
        .mem_read(mem_read_d),
        .mem_write(mem_write_d),
        .mem_to_reg(mem_to_reg_d),
        .reg_write(reg_write_d),
        .ctrl_sel(ctrl_sel)
        
    );

    M_Controller #(
    .N(N),
    .N_ALU_OP(N_ALU_OP),
    .N_OPCODE(N_OPCODE)
    ) Controller (
        .opcode(opcode),
        .alu_src(alu_src),
        .alu_op(alu_op),
        .reg_dest(reg_dest),
        .branch(branch),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .reg_write(reg_write)
    );
    M_Mux #(.DATA_N(9)) Controller_mux (
        .in_a({reg_dest, alu_src, mem_to_reg, reg_write, mem_read, mem_write, branch, alu_op}),
        .in_b(9'b0),
        .sel(ctrl_sel),
        .out({reg_dest_d, alu_src_d, mem_to_reg_d, reg_write_d, mem_read_d, mem_write_d, branch_d, alu_op_d}));

endmodule