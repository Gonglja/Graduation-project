module clk_set(clk_sys,rst_n,baud,clk);
input clk_sys;
input rst_n;
input [15:0]baud;
output clk;
reg clk;
reg [15:0]cnt;

//--算式:50_000_000/baud/16
//产生相应波特率的时钟
always@(posedge clk_sys or negedge rst_n)begin
	if(!rst_n)begin
			clk <= 1'b0;
			cnt <= 0;
		end
	else if(cnt == baud/2 -1)begin
			clk <= 1'b1;
			cnt <= cnt + 16'd1;
		end
	else if(cnt == baud -1 )begin
			clk <= 1'b0;
			cnt <= 16'd0;
		end
	else begin
			cnt <= cnt + 1'b1;
	end		
end
endmodule
