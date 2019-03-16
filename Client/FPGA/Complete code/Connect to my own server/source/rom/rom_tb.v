`timescale 1ns/1ps
module rom_tb;
reg clk_sys,rst_n;
wire [7:0]q;

initial begin
	clk_sys = 0;
	rst_n = 0;
	#1000.1 rst_n =1;
end
always #10 clk_sys=~clk_sys;
rom rom(	
			.clk_sys(clk_sys),
			.rst_n(rst_n),
			.q(q)
);

endmodule