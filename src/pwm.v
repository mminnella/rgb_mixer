`default_nettype none
`timescale 1ns/1ns
module pwm #(
	parameter WIDTH = 8,
 	parameter INVERT = 0
	)(
	input wire clk,
	input wire reset,
	output wire out,
	input wire [WIDTH-1:0] level
	);

	reg [WIDTH-1:0] counter;
	wire pwm_on = counter < level;

	always @(posedge clk) begin
		counter <= counter + 1'b1;
		if (reset) begin
			counter <= 0;
		end
	end

	assign out = (reset == 1'b1) ? 1'b0:
	       (INVERT == 1'b0) ? pwm_on: ! pwm_on;

endmodule
