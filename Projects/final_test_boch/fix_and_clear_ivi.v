module fix_and_clear_ivi(
	input clk,
	input rst_n,
	input en,
	output reg fix,
	output reg clrn = 1'b1
);

	reg en_delay;
	reg delay;
	reg clrn_reg;

	wire cout;

	defparam cnt_mod_50.width_cnt = 9;
	defparam cnt_mod_50.mod_cnt   = 50;

	counter_mod cnt_mod_50(
		.clk(clk),
		.rst_n(rst_n),
		.cout(cout)
	);

	always @(posedge cout or negedge clrn)
	begin
		if(!clrn)
			en_delay <= 1'b0;
		else
			en_delay <= en;  
	end

	always @(posedge cout)
	begin
		delay <= en_delay;
		fix <= delay;
		clrn_reg <= fix;
		clrn <= ~clrn_reg;
	end

endmodule
