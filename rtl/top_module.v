`timescale 1ns / 1ps
module top_module(
    input wire clk,          				// 100 MHz clock
    input wire rst,          				// Reset button
	input wire [6:0] angle_degree,			// angle input
	input wire select_sw,						//sine or cosine
    output [6:0] seg,        				// 7-segment display output
    output [3:0] an,        					// Enable signals for multiplexing   
    output dp
);

wire signed [31:0] z0,xn,yn,zn;
wire signed [31:0] selected_q16,scaled_value;
wire [9:0] fraction_value;
wire [3:0] digit;
wire [3:0] digit0;
wire [3:0] digit1;
wire [3:0] digit2;
wire [3:0] digit3;

	
    assign z0 = {25'd0, angle_degree} << 16;
	
//cordic
    cordic cordic_dut (
		.z0(z0) ,
		.xn(xn) ,	//cosine_q16
		.yn(yn) ,	//sine_q16
		.zn(zn) 
		);
		
// This is where you put the sine/cosine selection
	assign selected_q16 = (select_sw == 1'b0) ? yn : xn;
	
        assign scaled_value = (selected_q16 * 1000) >>> 16;

        // Separate integer part and fractional part
        //
        // Example:
        // scaled_value = 707
        // display = 0.707
		
        assign digit3 = scaled_value / 1000;

        assign fraction_value = scaled_value % 1000;

        assign digit2 = fraction_value / 100;
        assign digit1 = (fraction_value % 100) / 10;
        assign digit0 = fraction_value % 10;
		
 // Multiplexing Display for 3 Digits
    tdm_digit_select tdm_dut(
        .clk(clk),  // Fast clock for switching
        .rst(rst),
        .d0(digit0),
        .d1(digit1),
        .d2(digit2),
        .d3(digit3),
        .digit(digit),
        .an(an),
	.dp(dp)
    );                          
    
    
    // Instantiate the seven-segment decoder
    seven_seg_decoder decoder (
        .bin(digit),
        .seg(seg)
    );
		
endmodule
