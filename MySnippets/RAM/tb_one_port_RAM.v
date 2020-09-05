
`timescale 1ns/1ns

module testbench;
	reg [3:0] data_in;
	reg [5:0] addr;
	reg 		 we;
	reg       clk;
	
	wire [3:0] data_out;
	wire [5:0] addr_out;

	one_port_RAM dut (data_in, addr, we, clk, data_out, addr_out);
    
	initial 
	begin
		clk		= 0;
		we 		= 0;
		addr 	= 6'b000000;
		data_in = 4'b0000; 

		#20 we = 1;                  
		for(addr = 0; addr < 6; addr = addr + 1) begin
			#20 data_in = data_in + 1;
		end

		#20 we = 0;
		for(addr = 0; addr < 6; addr = addr + 1)
			#20;    
		end
    
	always 
		#10 clk = ~clk;
    
	initial 
		#300 $finish;

    initial 
       $monitor("data_in=%b addr=%b we=%b clk=%b data_out=%b addr_out=%b", 
            data_in, addr, we, clk, data_out, addr_out); 

endmodule
