module uart_rx #(
    parameter pBAUD_RATE,
    parameter pSYS_CLK_FREQ,
	parameter STOP_BITS = 1, // Number of Stop bits
	parameter DATA_BITS = 8
  )(
    input rx,
    input rst,
    input clk,
    output reg [DATA_BITS - 1:0] data_out
  );
  
  parameter state_NOT_IDLE = 2'b00;
  parameter state_IDLE 	   = 2'b01;
  parameter state_STOP_BIT = 2'b10;
  
  reg [1:0] state = state_IDLE;
  
  parameter no_of_data_bit = DATA_BITS - 1;
  
  reg [3:0] counter;
  reg [2:0] index;
  reg [1:0] stop_counter;
  
	always @(posedge clk or posedge rst) begin
		if(rst == 1) begin
			state <= state_IDLE;
			index <= 0;
			data_out <= 0;
			counter <= 0;
			stop_counter <= 0;
		end
		else begin
		
			data_out <= data_out; //default Output Value
			
			case (state)
				state_IDLE: begin
					data_out <= 0;
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
				state_NOT_IDLE: begin
					if(counter == 4'd15) begin
						counter <= 0;
						data_out <= data_out | rx << index;
						if(index == no_of_data_bit) begin
							state <= state_STOP_BIT;
						end
						index <= index + 1;
					end
					else begin
						counter <= counter + 1;
					end
				end
				state_STOP_BIT: begin
					data_out <= data_out;
					if(counter == 4'd15) begin
						counter <= 0;
						if(stop_counter == STOP_BITS) begin
							state <= state_IDLE;
							stop_counter <= 0;
						end
						else begin
							stop_counter <= stop_counter + 1;
						end
					end
					else begin
						counter <= counter + 1;
					end
				end
				default: begin
					data_out <= data_out;
				end
			endcase
		end
	end
  
endmodule
