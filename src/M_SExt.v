module M_SExt #(
    parameter N = 32,
    IMM_N = 16
) (
    input[IMM_N-1:0] immediate,
    output[N-1:0] sext_out
);
    assign sext_out ={{N-IMM_N {immediate[IMM_N-1]}}, immediate};
endmodule