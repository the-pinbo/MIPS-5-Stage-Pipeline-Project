module M_ForwardingUnit #(
    parameter N=32,
    N_REG = 256
)(
input  [$clog2(N)-1:0] rs_ex,
input  [$clog2(N)-1:0] rt_ex,
input  [$clog2(N)-1:0] write_reg_ex,
input  [$clog2(N)-1:0] write_reg_mem,
input  reg_write_mem, reg_write_wb,
output [1:0] ForwardA, 
output [1:0] ForwardB
);

assign ForwardA[0] = reg_write_wb && (write_reg_mem != 0) && !(reg_write_mem && (write_reg_ex != 0) && (write_reg_ex != rs_ex)) && (write_reg_mem == rs_ex);

assign ForwardB[0] = reg_write_wb && (write_reg_mem != 0) && !(reg_write_mem && (write_reg_ex != 0) && (write_reg_ex != rt_ex)) && (write_reg_mem == rt_ex);

assign ForwardA[1] = reg_write_mem && (write_reg_ex != 0) && (write_reg_ex == rs_ex);

assign ForwardB[1] = reg_write_mem && (write_reg_ex != 0) && (write_reg_ex == rt_ex);

endmodule
