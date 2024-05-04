module M_MemSync #(
    parameter REG_SIZE=32, N_REG = 256
) (
    input clk, mem_write, mem_read,
	input[$clog2(N_REG)-1:0] address,
	input[(REG_SIZE-1):0] write_data,
    output [(REG_SIZE-1):0] read_data
);
    reg[REG_SIZE-1:0] memory [N_REG-1:0];
    initial $readmemh("memdata.dat", memory);    
    
	assign read_data = memory[address];

	always @(negedge clk) begin
		if (mem_write) begin
			memory[address] <= write_data;
		end
	end

endmodule