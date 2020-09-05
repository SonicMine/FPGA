
`timescale 1ns/1ns

module testbench;

	localparam WIDTH = 8;

	reg        clk;
	reg        rst_n;
	reg        shift_en;
	reg        data_in;
	wire [7:0] data_out;
	wire       serial_out;
      
   
	shift_reg #(.WIDTH(WIDTH)) shft(
		.data_out   ( data_out   ),
		.serial_out ( serial_out ),
		.clk        ( clk        ),
		.rst_n      ( rst_n      ),
		.data_in    ( data_in    ),
		.shift_en   ( shift_en   )
	);

	initial
	begin
		clk = 0;
		forever #4 clk = ~clk;
	end

	task push;
		begin
			shift_en  = 1'b1;
			repeat(9) begin
			@(posedge clk)
				data_in = $urandom%2;
			end
			//shift_en  = 1'b0;
		end
	endtask

	task async_rst;
		rst_n = 1'b1;
	endtask
   
	initial 
	begin
		shift_en  = 1'b0;
		rst_n     = 1'b1;
		data_in   = 1'b0;
		
		async_rst();

		repeat(10) 
			#50 push; 
			
		#200 $finish;
	end
   
endmodule
