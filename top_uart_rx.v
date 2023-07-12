module top_uart_rx #(
		parameter pBAUD_RATE,
		parameter pSYS_CLK_FREQ,
		parameter STOP_BITS = 1, // Number of Stop bits
		parameter DATA_BITS = 8
	)(
		input rx,
		input rst,
		input sys_clk,
		output [DATA_BITS - 1:0] data_out
	);
	
	wire clk;

	// Creating an instance from uart_clk_for_sampling module
	uart_clk_for_sampling #(.pBAUD_RATE(pBAUD_RATE), .pSYS_CLK_FREQ(pSYS_CLK_FREQ)) clk_sampling (
		.sys_clk(sys_clk),
		.rst(rst),
		.sampling_clk(clk)
	);
	
	// Creating an instance from uart_rx module
	uart_rx #(.pBAUD_RATE(pBAUD_RATE), .pSYS_CLK_FREQ(pSYS_CLK_FREQ), .STOP_BITS(STOP_BITS), .DATA_BITS(DATA_BITS)) uart_rx_instance (
		.rx(rx),
		.rst(rst),
		.clk(clk),
		.data_out(data_out)
	);


endmodule
