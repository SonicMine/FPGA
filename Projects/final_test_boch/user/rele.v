module rele(
	input clk,
	//input reset,
	input [1:0] addr, 
	input [7:0] data, 
	output[11:0]imp
);

	reg [19:0] cnt = 20'd0;

	wire clear_cnt;
	reg out_r = 1;
	//reg [11:0]tmp_imp;

	assign clear_cnt = addr[0]|addr[1];

	always @(posedge clk or posedge clear_cnt) begin
		if(clear_cnt) begin
			cnt = 20'd0;
			out_r <= 1;
		end
		else begin 
			if (cnt <= 20'd1_000_000) begin 
				out_r <= 1;
				cnt <= cnt + 20'd1;
			end
			else begin
				out_r <= 0;
				cnt <= 20'd1_000_001;
			end
		end 
	end

	My_Latch #(8) Rele_Low_byte(
		.En(addr[0]),
		.D(data[7:0]),
		.Clear(out_r),
		.q(imp[7:0])
	);

	My_Latch #(4) Rele_High_byte(
		.En(addr[1]),
		.D(data[3:0]),
		.Clear(out_r),
		.q(imp[11:8])
	);

	/*
	genvar i ;
	generate for(i=0;i<12;i=i+1) begin : n_
		always @(posedge addr[i] or posedge out_r or posedge reset) begin 
			if(reset)
				imp[i] = 1'd0;
			else if(addr[i]) 
				imp[i] = 1'd1;;	
		end 
	end
	endgenerate*/


endmodule
