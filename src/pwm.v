`default_nettype none
`timescale 1ns/1ns
module pwm (
    input wire clk,
    input wire reset,
    output wire out,
    input wire [7:0] level
    );

    reg [7:0] counter;

    always @(posedge clk) begin
	    counter <= counter + 1'b1;

	    if (reset) begin
		    counter <= 0;
	    end
    end
    assign out = (reset == 1'b1) ? 1'b0:
	    (counter < level) ? 1'b1 : 1'b0; 
endmodule
