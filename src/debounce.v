`default_nettype none
`timescale 1ns/1ns
module debounce #(
	parameter HIST_LEN = 8
)(
    input wire clk,
    input wire reset,
    input wire button,
    output reg debounced
);
	localparam on_value = 2 ** HIST_LEN - 1;
	reg [HIST_LEN-1:0] b_history;
	
	always @(posedge clk) begin	
	
		b_history <= { b_history[HIST_LEN-2:0], button };
		if ( b_history == on_value ) begin
			debounced <= 1;
		end

		if (b_history == {HIST_LEN{1'b0}} ) begin
			debounced <= 0;
		end

		if (reset) begin
			b_history <= 0;
			debounced <= 0;
		end
	
	
	end

endmodule
