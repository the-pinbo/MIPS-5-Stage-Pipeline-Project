module M_Mux #(
    parameter DATA_N = 8
) (
    input[DATA_N-1:0] in_a, in_b,
    input sel,
    output[DATA_N-1:0] out
);
    assign out = sel?in_b:in_a;
endmodule