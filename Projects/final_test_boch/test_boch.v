module test_boch(
	input 	clk_50,					// 91
	input 	OP_KGG,					// 90
	inout 	[7:0]Data,				// 148...157
	input 	[7:0]Addr,				// 158...169
	input 	wr_pld,					// 137
	input 	rd_pld,					// 136
	input   mpv_1_Hz,				// 120
	output  int1,					// 219
	input   SSP2_RxD_test, 			// 129
	output  Test_Out,				// 133
	input  	In_AA,					// 100	
	input  	In_BB,					// 99
	input  	In_CC,					// 98
	input  	Reset_MK,				// 106
	
	// Uart
	input  	UART1_TxD,				// 146
	input  	RxD_obmen,				// 200
	output 	UART1_RxD,				// 147
	output 	TxD_obmen,				// 196
	
	input  	UART2_TxD,
	input  	RxD_pevm,
	input 	TD1D_MPV, 
	output 	reg RD1D_MPV,
	output 	UART2_RxD,
	output 	TxD_pevm,
	
	output 	NSHDN_1,				// 202
	output 	NSHDN_2,				// 190
	output 	nMR,					// 118
	
	// Выходные герцы				// Номера контактов на EPF10K
	output  out_1Hz_1,				// 6	 			
	output  out_1Hz_2,				// 7
	output  out_1Hz_3,				// 8
	output  out_1Hz_C,				// 101
	output  out_1Hz_K,				// 102
	output  out_1Hz_B,				// 103
	output  out_1Hz_P,				// 105
	
	// Индикация
	output  [7:0]Ind,				// 207...218
	
	// DAC
	output  [13:0]DAC,
	output  Clock,
	
	// Rele
	output [11:0]KP
	
);

	/*******************************************************************
					user mux1 (сообщение "Измерение")
	*******************************************************************/
	mux_signal user_mux1(
		.clk(clk_50),
		.rst_n(rst_n_wire),  
		.in_0(/*mpv_wire*/out_1_hz_5us_wire),
		.in_1(In_AA),
		.in_2(In_BB),  
		.in_3(In_CC), 
		.data_wr(data_sync_wire[1:0]),
		.wr(out_bus_wr[4]),  
		.out(mux1_user_wire)
	);

	wire mux1_user_wire;

	/*******************************************************************
					user mux2 (сообщение "Измерение")
	*******************************************************************/
	mux_signal user_mux2(
		.clk(clk_50),
		.rst_n(rst_n_wire),  
		.in_0(/*mpv_wire*/out_1_hz_5us_wire),
		.in_1(In_AA),
		.in_2(In_BB),  
		.in_3(In_CC), 
		.data_wr(data_sync_wire[1:0]),
		.wr(out_bus_wr[5]),  
		.out(mux2_user_wire)
	);

	wire mux2_user_wire;
	 
	/*******************************************************************
					tuning mux (сообщение "Подстройка")
	*******************************************************************/
	mux_signal tuning_mux(
		.clk(clk_50),
		.rst_n(rst_n_wire),  
		.in_0(mpv_wire),
		.in_1(In_AA),
		.in_2(In_BB),  
		.in_3(In_CC), 
		.data_wr(data_sync_wire[1:0]),
		.wr(out_bus_wr[6]),  
		.out(mux_tuning_wire)
	);

	wire mux_tuning_wire;

	/*******************************************************************
					phasing mux (сообщение "Фазировка")  
	*******************************************************************/
	mux_signal phasing_mux(
		.clk(clk_50),
		.rst_n(rst_n_wire),  
		.in_0(mpv_wire),
		.in_1(In_AA),
		.in_2(In_BB),  
		.in_3(In_CC), 
		.data_wr(data_sync_wire[1:0]),
		.wr(out_bus_wr[7]),  
		.out(mux_phasing_wire)
	);

	wire mux_phasing_wire;

	/*******************************************************************
								test phasing 
	*******************************************************************/
	counter_fsv output_phasing_Hz(
		.clk(/*MyWire_5_MHz*/OP_KGG),
		.reset_fsv_en(out_bus_wr[14]),
		.in_hz(mux_phasing_wire),
		.data_in_wr(out_bus_wr[19:16]),
		.data_in(data_sync_wire),
		.sload(out_bus_wr[15]),
		.out_1_hz_5us(out_1_hz_5us_wire)
	);

	wire out_1_hz_5us_wire;
	/*******************************************************************
							intervalometr (freq)
	*******************************************************************/
	intervalometer ivi_freq(
		.clk_50(clk_50),
		.clk_5(MyWire_5_MHz),
		.rst_n(rst_n_wire),
		.in_a(input_AA_wire),
		.in_b(mux_tuning_wire),
		.read_byte(out_bus_rd[23:20]),
		.out(Data)
	);

	/*******************************************************************
							intervalometr (phase)
	*******************************************************************/
	intervalometer ivi_phase(
		.clk_50(clk_50),
		.clk_5(MyWire_5_MHz),
		.rst_n(rst_n_wire),
		.in_a(mux_phasing_wire),
		.in_b(out_1_hz_5us_wire),
		.read_byte(out_bus_rd[27:24]),
		.out(Data)
	);

	/*******************************************************************
							intervalometr (user)
	*******************************************************************/
	intervalometer ivi_user(
		.clk_50(clk_50),
		.clk_5(MyWire_5_MHz),
		.rst_n(rst_n_wire),
		.in_a(mux1_user_wire),
		.in_b(mux2_user_wire),
		.read_byte(out_bus_rd[31:28]),
		.out(Data)
	);

	/*******************************************************************
							synq imp
	*******************************************************************/
	wire input_AA_wire;
	wire rst_n_mpv_wire;
	reg mpv_reg;

	always @(posedge out_bus_wr[1] or posedge data_sync_wire[0] or negedge rst_n_wire) 
	begin 
		if(!rst_n_wire)
			mpv_reg = 0;
		else if(out_bus_wr[1]) 
			mpv_reg = data_sync_wire[0];	
	end   

	wire mpv_wire = mpv_reg ? mpv_1_Hz : 1'b0;

	/*******************************************************************
								   Leds
	*******************************************************************/
	My_Latch Ind_Latch(
		.En(out_bus_wr[8]),
		.D(data_sync_wire), 
		.q(Ind),
		.Clear(rst_n_wire)
	);

	/*******************************************************************
							  uart commutator
	*******************************************************************/
	always @(posedge out_bus_wr[9] or posedge data_sync_wire[0]) 
	begin 
		if(out_bus_wr[9]) 
			out_bus_uart_latch = data_sync_wire[0];	
	end 

	reg out_bus_uart_latch;

	always @*
		if(out_bus_uart_latch)
			RD1D_MPV = UART2_TxD;
		else
			RD1D_MPV = RxD_pevm;
		
	/*******************************************************************
									DAC data
	*******************************************************************/
	My_Latch #(8) DAC_Low_byte(
		.En(out_bus_wr[10]),
		.D(data_sync_wire[7:0]),
		.q(DAC[7:0]),
		.Clear(1'd1)
	);

	My_Latch #(8) DAC_High_byte(
		.En(out_bus_wr[11]),
		.D(data_sync_wire[7:0]),
		.q(DAC[13:8]),
		.Clear(1'd1)
	);

	assign Clock = clk_50;

	/*******************************************************************
							5 MHz(KG) -> 1 Hz 
	*******************************************************************/
	signal_1_Hz_of_5_MHz #(10) KG_1_Hz(
		.clk(OP_KGG),
		.out_1_Hz(input_AA_wire),
		.rst_n(rst_n_wire)//rst_n_mpv_wire
	);

	/*******************************************************************
							Управление Реле
	*******************************************************************/
	rele set_rele(
		.clk(clk_50),
		.addr(out_bus_wr[13:12]),
		.data(data_sync_wire),
		.imp(KP)
	);
	/*******************************************************************
								Reset
	*******************************************************************/
	reset reset(
		.clk(clk_50),
		.rst_n(rst_n_wire),
	);

	wire rst_n_wire;

	/*******************************************************************
							sync data\addr bus
	*******************************************************************/
	sync_parallel_bus main_sync_bus(	
		.clk(clk_50),
		.addr(Addr[7:0]),
		.data(Data[7:0]),
		.rst_n(rst_n_wire),
		.addr_sync(addr_sync_wire),
		.data_sync(data_sync_wire)
	);

	wire [7:0]addr_sync_wire;
	wire [7:0]data_sync_wire;

	/*******************************************************************
							50 MHz -> 5 MHz
	*******************************************************************/
	clock_generate clk_5_MHz(
		.clk(clk_50),
		.clk_5_MHz(MyWire_5_MHz)
	);

	wire MyWire_5_MHz;

	/*******************************************************************
									int1
	*******************************************************************/
	assign int1 = mpv_wire; //input_AA_wire

	/*******************************************************************
							output signals 1 Hz
	*******************************************************************/
	assign out_1Hz_C = out_1_hz_5us_wire;
	assign out_1Hz_K = out_1_hz_5us_wire;
	assign out_1Hz_P = out_1_hz_5us_wire;
	assign out_1Hz_B = out_1_hz_5us_wire;
	assign out_1Hz_1 = out_1_hz_5us_wire;
	assign out_1Hz_2 = out_1_hz_5us_wire;
	assign out_1Hz_3 = out_1_hz_5us_wire;

	decode wr_decoder(
		.clk(clk_50),
		.en(wr_pld),
		.addr(addr_sync_wire),
		.out(out_bus_wr)
	);

	wire [31:0]out_bus_wr;

	decode rd_decoder(
		.clk(clk_50),
		.en(rd_pld),
		.addr(addr_sync_wire),
		.out(out_bus_rd)
	);

	wire [31:0]out_bus_rd;

	assign Test_Out = SSP2_RxD_test;

	assign UART2_RxD = TD1D_MPV;
	assign TxD_pevm  = TD1D_MPV; // 194 = 143 (ПЭВМ)            UART2_TxD						

	//assign Ind = Data;
	assign NSHDN_1 = 1; // 202
	assign NSHDN_2 = 1; // 190
	assign nMR = 1;

	/*******************************************************************
							  ПК <-> МПВ
	*******************************************************************/
	assign UART1_RxD = RxD_obmen;  
	assign TxD_obmen = UART1_TxD;

endmodule 
