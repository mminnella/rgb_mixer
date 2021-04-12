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
		
		if ({a, old_a, b, old_b} == 4'b1000) begin
			value <= value + INC_STEP;
		end
		
		if ({a, old_a, b, old_b} == 4'b0111) begin
			value <= value + INC_STEP;
		end

		if ({a, old_a, b, old_b} == 4'b0010) begin
			value <= value - INC_STEP;
		end
		
		if ({a, old_a, b, old_b} == 4'b1101) begin
			value <= value - INC_STEP;
		end

		old_a <= a;
		old_b <= b;
	

		if (reset) begin
			value <= 0;
		end


	end



endmodule
