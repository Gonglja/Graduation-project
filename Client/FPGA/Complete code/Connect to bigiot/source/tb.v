`timescale 1ns/1ps
module tb;
reg  clk,rst_n;

wire lcd_rs,lcd_rw,lcd_en;
wire [7:0]lcd_data;

initial
	begin
		clk = 0;
		rst_n = 0;
		#1000.1 rst_n = 1;
	end

always #10 clk=~clk;
top top(
		.clk(clk),
		.rst_n(rst_n),
		.lcd_rs(lcd_rs),
		.lcd_en(lcd_en),
		.lcd_rw(lcd_rw),
		.lcd_data(lcd_data)
		);

endmodule
