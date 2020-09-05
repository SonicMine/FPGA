module param_selector_generate 
#( parameter DATA_WIDTH = 8, parameter INPUT_CHANNELS = 2)(
    input   [(INPUT_CHANNELS * DATA_WIDTH) - 1:0] data,
    input   [INPUT_CHANNELS - 1:0]         	      sel,   
    output	[DATA_WIDTH - 1:0]                    y
);

genvar i;
generate
    for(i=0;i<INPUT_CHANNELS;i=i+1) 
    begin: gen_array
        assign y = sel[i] ? data[((i + 1) * DATA_WIDTH) - 1 : (i * DATA_WIDTH)] : {DATA_WIDTH{1'bx}};
    end
endgenerate

endmodule
