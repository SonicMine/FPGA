module full_adder(
    input  x, y, carry_in,
	output z, carry_out
);
    assign {carry_out, z} = x + y + carry_in;
	
endmodule
