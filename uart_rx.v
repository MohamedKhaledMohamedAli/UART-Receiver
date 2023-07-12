module uart_rx #(
    parameter pBAUD_RATE,
    parameter pSYS_CLK_FREQ,
	parameter DATA_BITS = 8
  )(
    input rx,
    input rst,
    input clk,
    output reg [DATA_BITS - 1:0] data_out
  );
  
  parameter state_IDLE = 1;
  parameter state_NOT_IDLE = 0;
  
  reg state = state_IDLE;
  
  parameter no_of_data_bit = DATA_BITS - 1;
  
  reg [3:0] counter = 0;
  reg [2:0] index = 0;
  
  always @(posedge clk or posedge rst) begin
    if(rst == 1) begin
		state <= state_IDLE;
		index <= 0;
		data_out <= 0;
		counter <= 0;
    end
    else begin
		if(state == state_IDLE) begin
			counter <= counter;
			data_out <= data_out;
			index <= index;
			state <= state;
			if(rx == 0) begin
				counter <= counter + 1;
				if(counter == 4'd8) begin	// To reach middle of start bit
					state <= state_NOT_IDLE;
					index <= 0;
					counter <= 0;
					data_out <= 0;
				end
			end
		end
		else begin
			if(counter == 4'd15) begin
				counter <= 0;
				data_out <= data_out | rx << index;
				if(index == no_of_data_bit) begin
					state <= state_IDLE;
				end
				else begin
					state <= state;
				end
				index <= index + 1;
			end
			else begin
				counter <= counter + 1;
				data_out <= data_out;
				index <= index;
				state <= state;
			end
		end
    end
  end
  
endmodule
