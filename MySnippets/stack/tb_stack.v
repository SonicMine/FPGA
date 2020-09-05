
`timescale 1ns/1ns

module testbench;
	reg 		  clk;
	reg 		  rst;
	reg 		  push;
	reg 		  pop;
	reg  [7:0] write_data;
	wire [7:0] read_data;

	stack dut (clk, rst, push, pop, write_data, read_data);
	
	initial 
	begin
		clk 	= 1;
		rst 	= 1;
		push 	= 1;
		pop 	= 0;
		
		write_data = 8'b00000000; 
		
		#20 					     			    
			write_data = 8'b00000001;
			
		#10
			rst = 0;
			
		#10 					     			    
			write_data = 8'b00000010;
			
		#20 					     			    
			write_data = 8'b00000011;
			
		#20 					     			    
			write_data = 8'b00000100;
			
		#20 					     			    
			write_data = 8'b00000101;
			
		#20 					     			    
			write_data = 8'b00000110;
			push 	= 0;
			pop 	= 1;
			
		#20 					     			    
			write_data = 8'b00000111;
			
		#20 					     			    
			write_data = 8'b00001000;
			
		#20 					     			    
			write_data = 8'b00001001;
			
		#20 					     			    
			write_data = 8'b00001011;
	end
	
	always 
		#10 clk = ~clk;

	initial 
		#220 $finish;

   initial 
       $monitor("clk=%b rst=%b push=%b pop=%b write_data=%b read_data=%b", 
			clk, rst, push, pop, write_data, read_data);

endmodule
