module M_MemAsync #(
    parameter REG_SIZE=32, N_REG = 256
) (
    input[$clog2(N_REG)-1:0] pc_addr,
    output [(REG_SIZE-1):0] instruction
);
    reg[REG_SIZE-1:0] memory [N_REG-1:0];
    initial $readmemh("mem_instr_machinecode_hazards.dat", memory);    
    assign instruction = memory[pc_addr];

endmodule