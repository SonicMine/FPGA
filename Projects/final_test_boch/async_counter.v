module async_counter
#(parameter width_cnt = 26)(
	input clk,
	input clrn,
	input cnt_en,
	input cnt_frw,
	output [width_cnt - 1:0] out
);

	wire [width_cnt - 1:0] q;

	tff  t_0_U(
		.t(cnt_en), 
		.clk(clk),   
		.clrn(clrn), 
		.q(q[0])
	);

	genvar i;
	generate for(i = 1; i < width_cnt; i = i + 1) 
		begin : t_
			tff  U(
				.t(1'b1), 
				.clk(q[i-1]),  
				.clrn(clrn), 
				.q(q[i])
			); 
		end
	endgenerate

	assign out = cnt_frw ? q : (1 + ~q);

endmodule
