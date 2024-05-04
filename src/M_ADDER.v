module M_ADDER #(
    parameter N = 3
) (
    input[N-1:0] a,b,
    input c,
    output[N-1:0] sum,
    output carry
);
    assign {carry,sum} = a + b + c;
    
endmodule