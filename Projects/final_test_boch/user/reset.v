module reset(
	input clk,
	output reg rst_n
);

	reg [3:0] cnt = 4'd0;

	always @(posedge clk)
	begin
		if (cnt <= 4'd7) begin 
			rst_n <= 0;
			cnt   <= cnt + 4'd1;
		end
		else begin
			rst_n <= 1;
			cnt   <= 4'd15;
		end
	end

endmodule
