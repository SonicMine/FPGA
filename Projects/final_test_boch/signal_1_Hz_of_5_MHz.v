module signal_1_Hz_of_5_MHz(
	input clk,
	input rst_n,
	output reg out_1_Hz = 1'b0
);

	parameter TIMP = 1; // us
		
	reg [22:0] cnt = 23'b0;

	always @(posedge clk or negedge rst_n)
	begin
		if (!rst_n)
		begin 
			cnt <= 23'b0;
			out_1_Hz = 1'b0;
		end
		else
		begin
			if(cnt <= 4_999_998) 
				cnt <= cnt + 23'b1;
			else 
				cnt <= 23'b0;
				
			if(cnt < (TIMP * 5))
				out_1_Hz <= 1'b1;
			else 
				out_1_Hz <= 1'b0;
		end
	end
 
endmodule 