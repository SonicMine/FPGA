module decoder_case (
	input enable,
	input [3:0] binary_in,
	output reg [15:0] decoder_out
);

	always @(*)
	begin
		decoder_out = 0;
		if(enable) begin
			case(binary_in)
				4'h0 : decoder_out = 16'h1;
				4'h1 : decoder_out = 16'h2;
				4'h2 : decoder_out = 16'h4;
				4'h3 : decoder_out = 16'h8;
				4'h4 : decoder_out = 16'h10;
				4'h5 : decoder_out = 16'h20;
				4'h6 : decoder_out = 16'h40;
				4'h7 : decoder_out = 16'h80;
				4'h8 : decoder_out = 16'h100;
				4'h9 : decoder_out = 16'h200;
				4'hA : decoder_out = 16'h400;
				4'hB : decoder_out = 16'h800;
				4'hC : decoder_out = 16'h1000;
				4'hD : decoder_out = 16'h2000;
				4'hE : decoder_out = 16'h4000;
				4'hF : decoder_out = 16'h8000;
			endcase
		end
	end	
	
endmodule
