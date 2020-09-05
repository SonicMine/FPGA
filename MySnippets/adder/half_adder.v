module half_adder(
	input  x, y, 
    output z,
    output carry_out
);
	assign {carry_out, z} = x + y;
	
endmodule
