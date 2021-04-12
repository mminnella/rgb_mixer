`default_nettype none
`timescale 1ns/1ns
module encoder #(
	parameter DATA_LEN = 8,
       	parameter INC_STEP = 1	
)(
    input clk,
    input reset,
    input a,
    input b,
    output reg [DATA_LEN-1:0] value
);

	reg old_a;
	reg old_b;

	always @ (posedge clk) begin
		
		case ({a, old_a, b, old_b})
			4'b1000 : value <= value + INC_STEP;
			4'b0111 : value <= value + INC_STEP;
			4'b0010 : value <= value - INC_STEP;
			4'b1101 : value <= value - INC_STEP;
		endcase			

		old_a <= a;
		old_b <= b;
	

		if (reset) begin
			value <= 0;
		end


	end



endmodule
