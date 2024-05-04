// `include "M_Mux.v"
// `include "M_BranchAddressCalculator.v"
// `include "M_ALUControl.v"
// `include "M_PiplineALU.v"

module M_PiplineStage3EX #(
    parameter N=32,
    N_REG = 5,
    N_FN_FIELD = 6,
    N_ALU_CTRL = 4,
    N_ALU_OP = 2 

)(
    // control signals
    input clk,
    input reset,
    input alu_src,
    input[N_ALU_OP-1:0] alu_op,
    input reg_dest,
    input [1:0] ForwardA, ForwardB,
    input ex_flush,
    
    // program counter
    input[N-1:0] pc_in,
    // read data 1
    input[N-1:0] read_data_1,
    // read data 2
    input[N-1:0] read_data_2,
    // 16 bit immediate
    input[N-1:0] sext_imm_16,
    // write back register Rt
    input[$clog2(N_REG)-1:0] rt,
    // write back register Rd
    input[$clog2(N_REG)-1:0] rd,
    // data for forwarding logic
    input[N-1:0] alu_out_ex_in,
    // data for forwarding logic
    input[N-1:0] write_data_wb,
    
    // branch address
    output reg[N-1:0] branch_addr_ex,
    // zero flag
    output reg zero_ex,
    // ALU result
    output reg[N-1:0] alu_out_ex,
    // write register
    output reg[$clog2(N_REG)-1:0] write_reg_ex,
    // write data
    output reg[N-1:0] write_data_ex,
    
    // Saved control signals
    // MEM
    input branch_ex,
    output reg branch_mem,
    input mem_read_ex,
    output reg mem_read_mem,
    input mem_write_ex,
    output reg mem_write_mem,
    // WB
    input mem_to_reg_ex,
    output reg mem_to_reg_mem,
    input reg_write_ex,
    output reg reg_write_mem

);
    // effective branch address calculation
    wire[N-1:0] branch_address;
    M_BranchAddressCalculator #(.N(N)) BranchAddressCalculator(
        .sext_imm_16(sext_imm_16),
        .pc(pc_in),
        .npc(branch_address)
    );

    // ALU
    wire[N_ALU_CTRL-1:0] alu_ctrl;
    M_ALUControl ALUController (
        .alu_op(alu_op),
        .fn_field(sext_imm_16[N_FN_FIELD-1:0]),
        .alu_ctrl(alu_ctrl)
    );
    
    //For Forwarding logic
    wire [N-1:0] ForwardA_out;
    M_Mux_3in #(.DATA_N(N))ForwardA_Mux(
        .in_a(read_data_1),
        .in_b(alu_out_ex_in),
        .in_c(write_data_wb),
        .in_d({32'b0}),
        .sel(ForwardA),
        .out(ForwardA_out)
    );
    wire [N-1:0] ForwardB_out;
    M_Mux_3in #(.DATA_N(N))ForwardB_Mux(
        .in_a(read_data_2),
        .in_b(alu_out_ex_in),
        .in_c(write_data_wb),
        .in_d({32'b0}),
        .sel(ForwardB),
        .out(ForwardB_out)
        );    
    wire[N-1:0] alu_op_b;
    M_Mux #(.DATA_N(N)) ALUMux (
        .in_a(ForwardB_out),
        .in_b(sext_imm_16),
        .sel(alu_src),
        .out(alu_op_b)
    );
    wire alu_out_zero;
    wire[N-1:0] alu_out_result;
    M_PiplineALU ALU(
        .op_a(ForwardA_out),
        .op_b(alu_op_b),
        .alu_ctrl(alu_ctrl),
        .zero(alu_out_zero),
        .result(alu_out_result)
    );

    wire[$clog2(N_REG)-1:0] write_reg;
    M_Mux #(.DATA_N($clog2(N_REG))) RegDestMux (
        .in_a(rt),
        .in_b(rd),
        .sel(reg_dest),
        .out(write_reg)
    );
    wire [2*N-1:0] product_2N;
    wire [N-1:0] product_N;
    M_NBitArrayMul #(.N(N)) Int_Multiplier (
    .a(read_data_1),
    .b(read_data_1),
    .product(product_2N));
    
    assign product_N = product_2N[N-1:0];
    assign ismul = (alu_op[1:0] == 2'b01) && (rd[4:0] == 5'b00000) && (sext_imm_16[5:0] ==  6'b000010);
    wire [N-1:0]alu_out_withMul;
    M_Mux #(.DATA_N(N)) AluoutMux (
        .in_a(alu_out_result),
        .in_b(product_N),
        .sel(ismul),
        .out(alu_out_withMul)
    );
    // Saving the states in the pipline registers
    always@(posedge clk) begin
        
        // branch address 
        branch_addr_ex <= branch_address;
        zero_ex <= alu_out_zero;
        alu_out_ex <= alu_out_withMul ;
        write_reg_ex <= write_reg;
        write_data_ex <= read_data_2 ;

        // Save the control signals
        // MEM
        if(ex_flush) begin
            branch_mem <= 0;
            mem_read_mem <= 0; 
            mem_write_mem <= 0;
            // WB
            mem_to_reg_mem <= 0;
            reg_write_mem <= 0;
        end
        else begin
            branch_mem <= branch_ex;
            mem_read_mem <= mem_read_ex; 
            mem_write_mem <= mem_write_ex;
            // WB
            mem_to_reg_mem <= mem_to_reg_ex;
            reg_write_mem <= reg_write_ex;
        end

    end
    
endmodule