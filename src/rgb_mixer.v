`default_nettype none
`timescale 1ns/1ns
module rgb_mixer (
    input clk12MHz,
    input reset,
    input [2:0] enca, //enca_0, enca_1, enca_2
    input [2:0] encb, //encb_0, encb_1. encb_2
    output [2:0] pwm_out //pwm0_out, pwm1_out, pwm2_out
);
    wire [2:0] enca_db; //enca_db0, enca_db1, enca_db2
    wire [2:0] encb_db; //encb_db0, encb_db1, encb_db3
    wire [7:0] enc0, enc1, enc2;
    reg [7:0] clk_div;
    wire clk;

    // debouncers, 2 for each encoder
    debounce #(.HIST_LEN(8)) debounce0_a(.clk(clk), .reset(reset), .button(enca[0]), .debounced(enca_db[0]));
    debounce #(.HIST_LEN(8)) debounce0_b(.clk(clk), .reset(reset), .button(encb[0]), .debounced(encb_db[0]));

    debounce #(.HIST_LEN(8)) debounce1_a(.clk(clk), .reset(reset), .button(enca[1]), .debounced(enca_db[1]));
    debounce #(.HIST_LEN(8)) debounce1_b(.clk(clk), .reset(reset), .button(encb[1]), .debounced(encb_db[1]));

    debounce #(.HIST_LEN(8)) debounce2_a(.clk(clk), .reset(reset), .button(enca[2]), .debounced(enca_db[2]));
    debounce #(.HIST_LEN(8)) debounce2_b(.clk(clk), .reset(reset), .button(encb[2]), .debounced(encb_db[2]));

    // encoders
    encoder #(.WIDTH(8)) encoder0(.clk(clk), .reset(reset), .a(enca_db[0]), .b(encb_db[0]), .value(enc0));
    encoder #(.WIDTH(8)) encoder1(.clk(clk), .reset(reset), .a(enca_db[1]), .b(encb_db[1]), .value(enc1));
    encoder #(.WIDTH(8)) encoder2(.clk(clk), .reset(reset), .a(enca_db[2]), .b(encb_db[2]), .value(enc2));

    // pwm modules
    pwm #(.WIDTH(8)) pwm0(.clk(clk), .reset(reset), .out(pwm_out[0]), .level(enc0));
    pwm #(.WIDTH(8)) pwm1(.clk(clk), .reset(reset), .out(pwm_out[1]), .level(enc1));
    pwm #(.WIDTH(8)) pwm2(.clk(clk), .reset(reset), .out(pwm_out[2]), .level(enc2));

    always @ (posedge clk12MHz) begin
    	clk_div <= clk_div + 1'b1;
    	if (reset) begin
    		clk_div <=0;
    	end

    end

    assign clk = (clk_div[7]) ? 1'b1 : 1'b0;
endmodule
