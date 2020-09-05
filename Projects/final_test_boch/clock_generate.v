module clock_generate(
	input clk,
	input rst_n,
	output reg clk_5_MHz = 1'b0
);

	reg [3:0] cnt = 4'b0;

	always @(posedge clk)
	begin
		if(cnt > 3) begin
			cnt <= 0;
			clk_5_MHz <= ~clk_5_MHz;
		end
		else 
			cnt <= cnt + 4'b1;
	end

endmodule 
