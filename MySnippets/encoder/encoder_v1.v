module encoder_v1(
	input 		[15:0] 	encoder_in,
	output reg 	[3:0]  	binary_out,
	input 			   	enable
);

always @(*) 
begin
    binary_out = 0;
    if (enable) begin
		case (encoder_in)
			16'h1    : binary_out = 0;
			16'h2    : binary_out = 1;
			16'h4    : binary_out = 2;
			16'h8    : binary_out = 3;
			16'h10   : binary_out = 4;
			16'h20   : binary_out = 5;
			16'h40   : binary_out = 6;
			16'h80   : binary_out = 7;
			16'h100  : binary_out = 8;
			16'h200  : binary_out = 9;
			16'h400  : binary_out = 10;
			16'h800  : binary_out = 11;
			16'h1000 : binary_out = 12;
			16'h2000 : binary_out = 13;
			16'h4000 : binary_out = 14;
			16'h8000 : binary_out = 15;
		endcase
    end
end
