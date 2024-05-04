module M_EQUAL(
    input[31:0] srca, writedata,
    output equalD);

    assign equalD = (srca==writedata);
    
endmodule