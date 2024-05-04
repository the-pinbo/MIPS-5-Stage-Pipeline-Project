// `include "PiplineMIPS.v"
`timescale 1ns/1ps
module tb_mips;
    //cpu testbench

    reg clk;
    reg res;
    PiplineMIPS MIPS_DUT(clk, res);

    // initial begin
    //     $dumpfile("MIPS_DUT.vcd");
    //     $dumpvars(0, MIPS_DUT);
    // end


    initial
    forever #5 clk = ~clk;

    initial begin

        clk = 0;
        res = 1;
        #10 res = 0;
		
        #3500 $finish;

    end

endmodule
