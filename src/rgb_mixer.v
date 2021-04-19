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
    wire [23:0] enc; //enc0 [23:16], enc1[15:8], enc2[7:0]; [7+i:i] con i da 0 a 16
    reg [7:0] clk_div;
    wire clk;


    wire [7:0] enc0 = enc[8*0 +: 8]; //temp reg for cocotb...yosys should optimize/removei f not needed
  
    wire [7:0] enc1 = enc[8*1 +: 8]; //temp reg for cocotb...yosys should optimize/removei f not needed
  
    wire [7:0] enc2 = enc[8*2 +: 8]; //temp reg for cocotb...yosys should optimize/removei f not needed

//    wire pwm_out0 = pwm_out[0]; //todo remove

//    wire pwm_out1 = pwm_out[1]; //todo remove

//    wire pwm_out2 = pwm_out[2]; //todo remove

   
    generate
	    genvar i;
	    for( i=0; i<3; i++) begin
	    
    // debouncers, 2 for each encoder
    debounce #(.HIST_LEN(8)) debounce0_a(.clk(clk), .reset(reset), .button(enca[i]), .debounced(enca_db[i]));
    debounce #(.HIST_LEN(8)) debounce0_b(.clk(clk), .reset(reset), .button(encb[i]), .debounced(encb_db[i]));

    // encoders
    encoder #(.WIDTH(8)) encoder0(.clk(clk), .reset(reset), .a(enca_db[i]), .b(encb_db[i]), .value(enc[8*i +: 8]));

    // pwm modules
    pwm #(.WIDTH(8)) pwm0(.clk(clk), .reset(reset), .out(pwm_out[i]), .level(enc[8*i +: 8]));
       	     end
    endgenerate

    always @ (posedge clk12MHz) begin
    	clk_div <= clk_div + 1'b1;
    	if (reset) begin
    		clk_div <=0;
    	end

    end

    assign clk = (clk_div[7]) ? 1'b1 : 1'b0;
endmodule
