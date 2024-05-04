module M_Mux_3in #(
    parameter DATA_N = 8
) (
    input[DATA_N-1:0] in_a, in_b, in_c, in_d,
    input [1:0]sel,
    output[DATA_N-1:0] out
);
    assign out = sel[1]? (sel[0]? in_d: in_c):(sel[0]? in_b: in_a);
endmodule