module ADC_dis(clk,rst_n,ren,scl,sda,dig_sel,dig_num,en);
	input clk,rst_n,ren;
	output scl,en;
	inout sda;
	output [2:0]dig_sel;
	output [7:0]dig_num;
	
	
	//--------------------------------
	wire [7:0]temp;

ad      u1(.clk(clk),
				.rst_n(rst_n),
				.ren(ren),
				.scl(scl),
				.sda(sda),
				.data_out(temp));
				
display  u2(.clk(clk), 
				.num(temp), 
				.dig_sel(dig_sel), 
				.en_o(en), 
				.dig_num(dig_num));
				

	
endmodule
