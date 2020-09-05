module My_Latch( 
	input [NBRB - 1:0]D,
	input En,
	input Clear,
	output reg [NBRB - 1:0]q
);

	parameter NBRB = 8;

	always @(posedge En or posedge D or negedge Clear)
	begin
		if(!Clear)
			q = 0;
		else if(En) 
			q = D;	
	end 

endmodule 