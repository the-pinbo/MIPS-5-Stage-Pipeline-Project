module M_NBitAdder #(
    parameter N = 3
) (
    input[N-1:0] a,b,
    output[N-1:0] sum,
    output carry
);
    assign {carry,sum} = a + b;
    
endmodule