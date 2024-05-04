// `include "M_MemAsync.v"

module M_PiplineStage1IF #(
    parameter N=32
)(
    input clk,
    input reset,
    input[N-1:0] pc_ex_mem,
    input pc_sel_ex_mem,
    input if_id_write,
    input PCWrite,
    input if_flush,
    output reg[N-1:0] instruction,
    output reg[N-1:0] npc
    // 
);
    // PC logic
    reg[N-1:0] pc;
    always @(posedge clk) begin
        if (reset)
            pc <= 32'b0;
        else if(PCWrite) begin
            if(pc_sel_ex_mem)
                pc <= pc_ex_mem;
            else 
                pc <= pc + 1;
            end
        else
            pc <= pc;
            
    end
    
    // Instruction memory
    localparam N_REG = 256;
    wire[N-1:0] inst_mem_out;    
    M_MemAsync InstructionMemory(pc[$clog2(N_REG)-1:0], inst_mem_out);

    // Saving the state in pipline registers
    always@(posedge clk) begin
        if(if_id_write) begin
            instruction <= inst_mem_out;
            npc <= pc;
        end
        else begin
            instruction <= instruction;
            npc <= npc;
        end
        if(if_flush)
            instruction <=0;
    end

endmodule