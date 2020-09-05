module mux_signal(
	input clk,
	input rst_n,
	input in_0,
	input in_1,
	input in_2,
	input in_3,
	input [1:0] data_wr,
	input wr,
	output reg out
);

	reg [1:0] sel = 2'b00;

	always @(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			sel <= 2'b00;
		else if(wr)
			sel <= data_wr;
	end

	always @(*)
	begin
		case(sel)
			2'b00:   out <= in_0;
			2'b01:   out <= in_1;
			2'b10:   out <= in_2;
			2'b11:   out <= in_3;
			default: out <= in_0;
		endcase
	end

endmodule
