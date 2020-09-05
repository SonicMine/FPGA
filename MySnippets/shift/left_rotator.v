module left_rotator	// Циклический шифтер
#(parameter WIDTH = 8, parameter SHIFT = 3)(
    input  [WIDTH - 1:0] x,
    input  [SHIFT - 1:0] shamt,
    output [WIDTH - 1:0] z
);

    wire [2 * WIDTH - 1:0] temp;
    assign temp = {x, x} << shamt;
    assign z = temp[2 * WIDTH - 1: WIDTH];
	
endmodule
