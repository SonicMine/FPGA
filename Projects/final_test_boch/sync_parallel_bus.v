module sync_parallel_bus(
   input clk,
   input rst_n,
   input [7:0] addr,
   input [7:0] data,
   output reg [7:0] addr_sync,
   output reg [7:0] data_sync
);

	always @(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
		begin
			addr_sync <= 6'd0;
			data_sync <= 8'd0;   
		end
		else
		begin
			addr_sync <= addr;
			data_sync <= data; 
	   end
	end
	
endmodule
