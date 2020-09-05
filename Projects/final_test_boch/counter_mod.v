module counter_mod
#(	parameter width_cnt = 9,
	parameter mod_cnt   = 10)(
	input clk,
	input rst_n,
	output cout
);

	reg [width_cnt-1:0] out;

	always @(posedge clk or negedge rst_n)
	begin
		if(!rst_n) 
			out <= 'd0;
		else if(out == (mod_cnt-1)) 
			out <= 'd0;
		else
			out <= out + 1'd1;
	end

	assign cout = (out == (mod_cnt - 1));

endmodule 
