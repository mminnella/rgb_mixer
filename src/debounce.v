`default_nettype none
`timescale 1ns/1ns
module debounce (
    input wire clk,
    input wire reset,
    input wire button,
    output reg debounced
);
	reg [7:0] b_history;
	
	always @(posedge clk) begin	
	
		b_history <= { b_history[6:0], button };
		if ( b_history == 8'b1111_1111) begin
			debounced <= 1;
		end

		if (b_history == 8'b0000_000) begin
			debounced <= 0;
		end

		if (reset) begin
			b_history <= 0;
			debounced <= 0;
		end
	
	
	end

endmodule
