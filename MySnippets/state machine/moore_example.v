module moore_example(
	input  clk,
    input  rst_n,
    input  en,
    input  in,
    output out
);

    parameter [1:0] S0 = 0, S1 = 1, S2 = 2;

    reg [1:0] state, next_state;

    always @(posedge clk or negedge rst_n) begin // Хранит состояние
        if(!rst_n)
            state <= S0;
        else if(en)
            state <= next_state;
	end

    always @* begin	// Переход
        case(state)        
        S0:
            if(in)
                next_state = S1;
            else
                next_state = S0;

        S1:
            if(in)
                next_state = S2;
            else
                next_state = S1;

        S2:
            if(in)
                next_state = S0;
            else
                next_state = S2;

        default:
            next_state = S0;

        endcase
	end

    assign out = (state == S2 || state == S1);

endmodule
