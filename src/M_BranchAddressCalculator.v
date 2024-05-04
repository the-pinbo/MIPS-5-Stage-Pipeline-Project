module M_BranchAddressCalculator #(
    parameter N = 32
) (
    input[N-1:0] sext_imm_16,
    input[N-1:0] pc,

    output[N-1:0] npc
);
    assign npc = pc + sext_imm_16;
    
endmodule