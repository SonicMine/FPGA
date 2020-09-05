module decode(
	input clk,
	input en,
	input [7:0] addr,
	output reg [31:0] out
);

	reg [31:0] out_reg;

	always @(posedge clk)
	begin
		if(en)
			out_reg <= 32'b1 << addr; 
		else 
			out_reg <= 32'b0;
		
		out <= out_reg; 
	end

endmodule 
