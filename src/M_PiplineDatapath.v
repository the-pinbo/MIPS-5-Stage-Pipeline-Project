module M_PiplineDatapath #(
    parameter N = 32,
    N_REG = 32,
    N_REG_MEMORY = 256,
    N_OPCODE = 6,
    N_ALU_OP = 2,
    N_FN_FIELD = 6,
    N_ALU_CTRL = 4,
    READ_REG1_IDX = 25, 
    READ_REG2_IDX = 20, 
    WRITE_REG_IDX = 20, 
    RT_IDX = 20,
    RD_IDX = 15,
    IMM_16 = 16
) (
    input clk,
    input reset,
    // opcode to the controller
    output[N_OPCODE-1:0] opcode,
    // EX
    input alu_src,
    input[N_ALU_OP-1:0] alu_op,
    input reg_dest,
    // MEM
    input branch,
    input mem_read,
    input mem_write,
    // WB
    input mem_to_reg,
    input reg_write,
    output ctrl_sel
);

    // Stage 1: IF
    wire[N-1:0] instruction_if_id;
    wire[N-1:0] pc_if_id;
    M_PiplineStage1IF #(
        .N(N)
        ) Stage1IF  (
        .clk(clk),
        .reset(reset),
        // input form EX-MEM reg
        .pc_ex_mem(branch_addr_ex_mem),
        // input from Stage 4 
        .pc_sel_ex_mem(pc_sel_ex_mem),
        .instruction(instruction_if_id),
        .npc(pc_if_id),
        .if_id_write(if_id_write),
        .PCWrite(PCWrite),
        .if_flush(pc_sel_ex_mem)
    );

    // Stage 2: ID
    // Assign opcode (Output to the controller) 
    assign opcode = instruction_if_id[N-1:N-N_OPCODE];
    wire[N-1:0] pc_id_ex;
    wire[N-1:0] read_data_1_id_ex;
    wire[N-1:0] read_data_2_id_ex;
    wire[N-1:0] sext_imm_16_id_ex;
    wire[$clog2(N_REG)-1:0] rs_id_ex;
    wire[$clog2(N_REG)-1:0] rt_id_ex;
    wire[$clog2(N_REG)-1:0] rd_id_ex;
    
    // EX control signals (IE-EX)
    wire alu_src_id_ex;
    wire[N_ALU_OP-1:0] alu_op_id_ex;
    wire reg_dest_id_ex;
    // MEM control signals (IE-EX)
    wire branch_id_ex;
    wire mem_read_id_ex;
    wire mem_write_id_ex;
    // WB control signals (IE-EX)
    wire mem_to_reg_id_ex;
    wire reg_write_id_ex;


    M_PiplineStage2ID #(
        .N(N),
        .N_REG(N_REG),
        .READ_REG1_IDX(READ_REG1_IDX), 
        .READ_REG2_IDX(READ_REG2_IDX), 
        .WRITE_REG_IDX(WRITE_REG_IDX), 
        .RT_IDX(RT_IDX),
        .RD_IDX(RD_IDX),
        .IMM_16(IMM_16),
        .N_ALU_OP(N_ALU_OP)
        ) Stage2ID(
        .clk(clk),
        .reset(reset),
        .instruction(instruction_if_id),
        .pc_in(pc_if_id),
        .pc_out(pc_id_ex),
        .reg_write_wb(reg_write_wb),
        .write_reg_wb(write_reg_wb),
        .write_data_wb(write_data_wb),
        .read_data_1(read_data_1_id_ex),
        .read_data_2(read_data_2_id_ex),
        .sext_imm_16(sext_imm_16_id_ex),
        .rs(rs_id_ex),
        .rt(rt_id_ex),
        .rd(rd_id_ex),
        .alu_src(alu_src),
        .alu_src_ex(alu_src_id_ex),
        .alu_op(alu_op),
        .alu_op_ex(alu_op_id_ex),
        .reg_dest(reg_dest),
        .reg_dest_ex(reg_dest_id_ex),
        .branch(branch),
        .branch_ex(branch_id_ex),
        .mem_read(mem_read),
        .mem_read_ex(mem_read_id_ex),
        .mem_write(mem_write),
        .mem_write_ex(mem_write_id_ex),
        .mem_to_reg(mem_to_reg),
        .mem_to_reg_ex(mem_to_reg_id_ex),
        .reg_write(reg_write),
        .reg_write_ex(reg_write_id_ex)
    );

    // Stage 3: EX
    // branch address (EX-MEM)
    wire[N-1:0] branch_addr_ex_mem;
    // zero flag (EX-MEM)
    wire zero_ex_mem;
    // ALU result (EX-MEM)
    wire[N-1:0] alu_out_ex_mem;
    // write register (EX-MEM)
    wire[$clog2(N)-1:0] write_reg_ex_mem;
    // write data (EX-MEM)
    wire[N-1:0] write_data_ex_mem;
    // MEM control signals (EX-MEM)
    wire branch_ex_mem;
    wire mem_read_ex_mem;
    wire mem_write_ex_mem;
    // WB control signals (EX-MEM)
    wire mem_to_reg_ex_mem;
    wire reg_write_ex_mem;

    M_PiplineStage3EX #(
        .N(N),
        .N_REG(N_REG),
        .N_FN_FIELD(N_FN_FIELD),
        .N_ALU_CTRL(N_ALU_CTRL),
        .N_ALU_OP(N_ALU_OP)
    ) Stage3EX (
        .clk(clk),
        .reset(reset),
        .alu_src(alu_src_id_ex),
        .alu_op(alu_op_id_ex),
        .reg_dest(reg_dest_id_ex),
        .pc_in(pc_id_ex),
        .read_data_1(read_data_1_id_ex),
        .read_data_2(read_data_2_id_ex),
        .sext_imm_16(sext_imm_16_id_ex),
        .rt(rt_id_ex),
        .rd(rd_id_ex),
        .branch_addr_ex(branch_addr_ex_mem),
        .zero_ex(zero_ex_mem),
        .alu_out_ex(alu_out_ex_mem),
        .write_reg_ex(write_reg_ex_mem),
        .write_data_ex(write_data_ex_mem),
        // control signals in pipline reg
        .branch_ex(branch_id_ex),
        .branch_mem(branch_ex_mem),
        .mem_read_ex(mem_read_id_ex),
        .mem_read_mem(mem_read_ex_mem),
        .mem_write_ex(mem_write_id_ex),
        .mem_write_mem(mem_write_ex_mem),
        .mem_to_reg_ex(mem_to_reg_id_ex),
        // input form stage 5
        .mem_to_reg_mem(mem_to_reg_ex_mem),
        .reg_write_ex(reg_write_id_ex),
        // input form stage 5
        .reg_write_mem(reg_write_ex_mem),
        // Forwarding
        .ForwardA(ForwardA),
        .ForwardB(ForwardB),
        .alu_out_ex_in(alu_out_ex_mem),
        .write_data_wb(write_data_wb),
        .ex_flush(pc_sel_ex_mem)
    );

    // Stage 4: MEM
    // load PC based on branch (Stage 1 (IF))
    wire pc_sel_ex_mem;
    wire[N-1:0] read_data_mem_wb;
    wire[N-1:0] alu_out_mem_wb;
    wire[$clog2(N)-1:0] write_reg_mem_wb;
    // WB control signals (MEM-WB)
    wire mem_to_reg_mem_wb;
    wire reg_write_mem_wb;
    M_PiplineStage4MEM #(
        .N(N),
        .N_REG(N_REG_MEMORY)
    ) Stage4MEM (
        .clk(clk),
        .reset(reset),
        .branch(branch_ex_mem),
        .mem_read(mem_read_ex_mem),
        .mem_write(mem_write_ex_mem), 
        .branch_addr(branch_addr_ex_mem),
        .zero(zero_ex_mem),
        .alu_out(alu_out_ex_mem),
        .write_reg(write_reg_ex_mem),
        .write_data(write_data_ex_mem),
        // load pc with branch address
        .pc_sel_mem(pc_sel_ex_mem),
        // pipline registers for WB stage
        .read_data_mem(read_data_mem_wb),
        .alu_out_mem(alu_out_mem_wb),
        .write_reg_mem(write_reg_mem_wb),
        // control signals in pipline reg
        .mem_to_reg_mem(mem_to_reg_ex_mem),
        .mem_to_reg_wb(mem_to_reg_mem_wb),
        .reg_write_mem(reg_write_ex_mem),
        .reg_write_wb(reg_write_mem_wb)
    );
    
    // Stage 5: WB
    wire reg_write_wb;
    wire[N-1:0]write_data_wb;
    wire[$clog2(N)-1:0]write_reg_wb;
    M_PiplineStage5WB #(
        .N(N),
        .N_REG(N_REG)
    ) Stage5WB (
        .clk(clk),
        .reset(reset),
        .mem_to_reg(mem_to_reg_mem_wb),
        .read_data(read_data_mem_wb),
        .alu_out(alu_out_mem_wb),
        .write_data_wb(write_data_wb),
        .reg_write(reg_write_mem_wb),
        .reg_write_wb(reg_write_wb),
        .write_reg(write_reg_mem_wb),
        .write_reg_wb(write_reg_wb)
    );
    
    M_ForwardingUnit #(.N(N),.N_REG(N_REG)) ForwardingUnit(
    .rs_ex(rs_id_ex),
    .rt_ex(rt_id_ex),
    .write_reg_ex(write_reg_ex_mem),
    .write_reg_mem(write_reg_mem_wb),
    .reg_write_mem(reg_write_ex_mem),
    .reg_write_wb(reg_write_wb),
    .ForwardA(ForwardA),
    .ForwardB(ForwardB)
    );
    
    Hazard_detection Hazard_detect(
    .rt_id_ex(rt_id_ex),
    .rs_rt(instruction_if_id[25:16]),
    .mem_read_id_ex(mem_read_id_ex),
    .ctrl_sel(ctrl_select),
    .if_id_write(if_id_write),
    .PCWrite(PCWrite)   

    
    );
    wire id_flush = pc_sel_ex_mem;
    assign ctrl_sel = ctrl_select || id_flush;
endmodule