
module M_MULT #(
    parameter N = 3
) (
    input[N-1:0] a, b,
    output[N-1:0] product
);
    assign product = a*b;
endmodule




