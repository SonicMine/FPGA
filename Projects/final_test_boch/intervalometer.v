module intervalometer(
   input clk_50,
   input clk_5,
   input rst_n,
   input in_a,
   input in_b,
   input [3:0] read_byte,
   output [7:0] out = 8'd0
);

	reg signed [31:0] interval = 32'h00000000;
	wire signed [25:0] cnt_1;
	wire signed [25:0] cnt_2;
	wire [8:0]  cnt_3;
	wire cout_3;
	wire [1:0] overflow;

	reg [1:0] en;
	wire [1:0] ready;
	wire [1:0] start;
	reg ready_all = 1'b0;
	reg overflow_all = 1'b0;

	reg [1:0] a;
	reg [1:0] b;
	wire [1:0] sign;
	reg [1:0] q_sign;

	wire en_wr;
	reg count_stop = 1'b0;

	wire clrn;
	wire [1:0] cnt_en;

	lock_and_count lac_1(
		.in_a(in_a),
		.in_b(in_b),
		.clk(clk_50),
		.clrn(clrn),
		.result(cnt_1),
		.overflow(overflow[0]),
		.stop(ready[0]),
		.cnt_en(cnt_en[0])
	);

	lock_and_count lac_2(
		.in_a(in_a),
		.in_b(in_b),
		.clk(~clk_50),
		.clrn(clrn),
		.result(cnt_2),
		.overflow(overflow[1]),
		.stop(ready[1]),
		.cnt_en(cnt_en[1])
	);

	always @(posedge clk_50)
	begin
		overflow_all <= overflow[0] | overflow[1];
		ready_all    <= ready[0] & ready[1];  
		count_stop   <= ready_all | overflow_all;
	end

	wire signed [31:0] summa = cnt_1 + cnt_2;
	wire signed [31:0] result = overflow_all ? 32'h7FFFFFFF : summa;
		
	fix_and_clear_ivi f_n_clrn_ivi(
		.clk(clk_5),
		.rst_n(rst_n),
		.en(count_stop),
		.fix(en_wr),
		.clrn(clrn)
	);

	always @(posedge en_wr)
		interval <= result;

	assign out = read_byte[0] ? interval[7:0]   : 8'hz;
	assign out = read_byte[1] ? interval[15:8]  : 8'hz;
	assign out = read_byte[2] ? interval[23:16] : 8'hz;
	assign out = read_byte[3] ? interval[31:24] : 8'hz;

endmodule
