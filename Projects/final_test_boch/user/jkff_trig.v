/*module jkff_trig(
   input j,
   input k,
   input clk,
   input clrn,
   output reg q = 1'b0
);

always @(posedge clk or negedge clrn)
begin
   if (!clrn)         q <= 1'b0;
   else if (!j && k)  q <= 1'b0;
   else if (j  && !k) q <= 1'b1;
   else if (j  && k)  q <= ~q;
end

endmodule*/

module jkff_trig( 
	input j,
	input k,
	input clk,
	input clrn,
	output reg q   = 1'b0,
	output reg q_n = 1'b1
);

	always @ (posedge clk or negedge clrn)
	begin
		if(!clrn) 
		begin
			q   <= 1'b0;
			q_n <= 1'b1;
		end
		else
		begin
			case({j,k})
				{1'b0, 1'b0}: begin q <= q;    q_n <= q_n;  end
				{1'b0, 1'b1}: begin q <= 1'b0; q_n <= 1'b1; end
				{1'b1, 1'b0}: begin q <= 1'b1; q_n <= 1'b0; end
				{1'b1, 1'b1}: begin q <= ~q;   q_n <= ~q_n; end
			endcase
		end
	end

endmodule
