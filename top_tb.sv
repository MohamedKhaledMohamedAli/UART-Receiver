
`timescale 1ns/1ns

module top_tb;

	reg clk=0;

	always #(5) clk=~clk;   // to get clk period = 10nsec= 0.01usec (1/100 MHZ) if using system freq=100MHZ

	wire rx_clk;
	reg rx_data_in_tb;
	reg rst;
	wire [7:0] rx_dout_tb;
  
	top_uart_rx #(.pBAUD_RATE(9600), .pSYS_CLK_FREQ(100000000)) uart_top_tb (
		.rx(rx_data_in_tb),
		.rst(rst),
		.sys_clk(clk),
		.data_out(rx_dout_tb)
	);
  
	reg [16:0] Tb;
	initial begin

		// since rx_clk = 6.5 usec, so Tb must be >=16rx_clk = 104000 nsec
		Tb <= 104000;

		rst <= 1;
		#2
		rst <= 0;
		rx_data_in_tb <= 1; //idle
		#Tb  
		rx_data_in_tb <= 0; // start
		#Tb

		/***********data bits  0101_1001  ****************/
		rx_data_in_tb <=1; 
		#Tb
		rx_data_in_tb <=0; 
		#Tb
		rx_data_in_tb <=0; 
		#Tb
		rx_data_in_tb <=1; 
		#Tb

		rx_data_in_tb <=1; 
		#Tb
		rx_data_in_tb <=0; 
		#Tb
		rx_data_in_tb <=1; 
		#Tb
		rx_data_in_tb <=0; 
		#Tb;

		// idle again
		rx_data_in_tb <=1; 

		$display("Tx data : 01011001");
		$display("Rx data = %b",rx_dout_tb);
		$finish();

	end


endmodule
