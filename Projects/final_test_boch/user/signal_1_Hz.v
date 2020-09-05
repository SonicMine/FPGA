module signal_1_Hz(
	input clk,
	input rst_n,
	output reg out_1_Hz = 1'b0
);

	parameter TIMP = 1; // us
		
	reg [25:0] cnt = 26'b0;

	always @(posedge clk or negedge rst_n)
	begin
		if (!rst_n) 
		begin 
			cnt <= 26'b0;
			out_1_Hz = 1'b0;
		end 
		else 
		begin
			if(cnt <= 49_999_999) 
				cnt <= cnt + 26'b1;
			else 
				cnt <= 26'b0;
			if(cnt < (TIMP * 50))
				out_1_Hz <= 1'b1;
			else 
				out_1_Hz <= 1'b0;
		end	
	end
 
endmodule 
