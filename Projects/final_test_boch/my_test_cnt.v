module my_test_cnt(
	input clk, 
	input en,
	input rst_n,
	output reg [7:0]cnt = 0,
	output reg rdy = 0
);

	always @(posedge clk  or negedge rst_n) 
	begin 
		if(!rst_n) 
		begin 
			cnt <= 0;
			rdy <= 0;
		end
		else 
		begin 
			if(cnt <= 255) 	
			begin
				cnt <= cnt + 1;
				rdy <= 0;
			end
			else 
			begin 
				cnt <= 0;
				rdy <= 1;
			end
		end 
	end

endmodule 
