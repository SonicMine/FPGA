module counter_fsv 
#(	parameter freq  = 32'd4_999_999, 
	parameter width = 32'd8)(
	input clk,
	input reset_fsv_en,	
	input in_hz,
	input sload,	
	input [7:0] data_in,
	input [3:0] data_in_wr,		   
	output reg out_1_hz_5us  = 1'b0
);

	reg [31:0] cnt    			 = 32'd0;
	reg [3:0]  rst_fsv           = 4'b0000;
	reg signed [31:0] sload_data = 32'd0;
	reg signed [31:0] shift      = 32'd0;

	wire reset_fsv;
	wire clrn;

	always @(posedge reset_fsv_en or negedge clrn)
	begin
		if(!clrn)
			rst_fsv[0] <= 1'b0;
		else 
			rst_fsv[0] <= 1'b1;
	end

	always @(posedge in_hz or negedge clrn)
	begin
		if (!clrn)
			rst_fsv[1] <= 1'b0;
		else 
			rst_fsv[1] <= rst_fsv[0];
	end

	dff rst_fsv_2(
		.d(rst_fsv[1]), 
		.clk(clk), 
		.clrn(clrn), 
		.q(rst_fsv[2])
	);

	always @(posedge clk)
	   rst_fsv[3] <= rst_fsv[2];

	assign clrn = ~rst_fsv[3];
	assign reset_fsv = rst_fsv[2] & ~rst_fsv[3];

	always @(posedge clk or posedge reset_fsv)
	begin
		if (reset_fsv) // чек зыс !!! 
		begin
			out_1_hz_5us <= 0;
			cnt          <= 2;
			shift        <= 0;
		end
		else
		begin
			if     (data_in_wr[0]) sload_data[7:0]   <= data_in[7:0];
			else if(data_in_wr[1]) sload_data[15:8]  <= data_in[7:0];
			else if(data_in_wr[2]) sload_data[23:16] <= data_in[7:0];
			else if(data_in_wr[3]) sload_data[31:24] <= data_in[7:0];
	   
			if(sload) 
				shift[31:0] <= sload_data[31:0];
	   
			if(cnt < width) 
				out_1_hz_5us <= 1'b1;
			else            
				out_1_hz_5us <= 1'b0;
		  
			if(cnt >= freq + shift) 
			begin
				cnt    <= 0;
				shift  <= 32'd0;
			end
			else 
				cnt <= cnt + 32'd1;      
		end
	end

endmodule
