module one_port_RAM
#(parameter DATA_WIDTH = 4, parameter ADDR_WIDTH = 6)(
	input [(DATA_WIDTH-1):0] data_in,
    input [(ADDR_WIDTH-1):0] addr,
    input we,
	input clk,
   
	output [(DATA_WIDTH-1):0] data_out,
    output [(ADDR_WIDTH-1):0] addr_out
);

	reg [DATA_WIDTH-1:0] ram [0:2**ADDR_WIDTH-1];
	reg [ADDR_WIDTH-1:0] addr_reg;					

    always @ (posedge clk) begin	
		if(we)                     
			ram[addr] <= data_in;      
			
		addr_reg <= addr;              
    end

   assign data_out = ram[addr_reg];  
   assign addr_out = addr_reg;        

endmodule
