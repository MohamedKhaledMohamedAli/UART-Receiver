module uart_clk_for_sampling #(
    parameter pBAUD_RATE = 1,
    parameter pSYS_CLK_FREQ = 1
  )(
    input rst,
    input sys_clk,
    output reg sampling_clk
  );
  
  reg [22:0] counter;
	wire [22:0] final_value;
	
	assign final_value = (pSYS_CLK_FREQ/(16*(pBAUD_RATE)) - 1)/2;
	
	always @(posedge sys_clk or posedge rst) begin
	  if(rst) begin
	    sampling_clk = 1;
	    counter = 0;
	  end
	  else begin
		  counter <= counter + 23'd1;
		  if(counter == final_value) begin
			 counter <= 0;
			 sampling_clk <= ~sampling_clk;
		  end
		 end
	end
  
endmodule
