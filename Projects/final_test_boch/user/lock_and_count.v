module lock_and_count(
   input in_a,
   input in_b,
   input clk,
   input clrn,
   output wire signed [25:0] result,
   output reg overflow = 1'b0,
   output reg stop = 1'b0,
   output reg cnt_en = 1'b0
);

	wire a;
	wire b;
	reg start = 1'b0;
	reg sign = 1'b0;
	wire q_sign;
	reg cnt_frw = 1'b0;

	wire signed [25:0] cnt;
	//reg signed [25:0] cnt = 'd0;

	reg en = 1'b0;
	//reg cnt_en = 1'b0;

	jkff_trig input_a (.j(in_a), .k(1'b0), .clk(clk), .clrn(clrn), .q(a));
	jkff_trig input_b (.j(in_b), .k(1'b0), .clk(clk), .clrn(clrn), .q(b));
	jkff_trig forward (.j(sign), .k(1'b0), .clk(clk), .clrn(clrn), .q(q_sign));

	always @(posedge clk)
	begin
		start <= a | b;
		stop  <= a & b;
		sign  <= a & ~b;
		cnt_frw <= ~q_sign;
		en <= (start & ~stop);
		overflow <= cnt_frw  ? (cnt < -24_999_999) : (cnt >  24_999_999);
		cnt_en <= (en & ~overflow);
	end

	defparam acnt.width_cnt = 26;

	async_counter acnt(
		.clk(clk),
		.clrn(clrn),
		.cnt_en(cnt_en),
		.cnt_frw(cnt_frw),
		.out(cnt)
	);

	assign result = cnt;

endmodule
