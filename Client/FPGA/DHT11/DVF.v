module DVF(CLK_50Mhz,clkout);
input CLK_50Mhz;
output reg clkout;
parameter divd=25;
reg[7:0] cnt;
initial begin
	 cnt<=8'b0;
	 clkout<=1'b0;
	 end
always@(posedge CLK_50Mhz)
	begin
	if(cnt<divd)
		cnt<=cnt+8'b1;
	else
	  begin
		cnt<=8'b0;
		clkout<=~clkout;
	  end
	end
endmodule 