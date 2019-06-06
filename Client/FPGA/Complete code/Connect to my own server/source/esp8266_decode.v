module esp8266_decode(rx_int,rx_data,clk,rst,data,oSpeaker_io);

input clk,rst,rx_int;
input [7:0] rx_data;

output [23:0]data;
output oSpeaker_io;
reg[3:0] count;
//9*4  48-36=12  3位数据
reg [7:0]rec;
reg flag;

//`define _A 8'h41

always@(posedge clk or negedge rst)
	begin
		if(!rst)
			flag<=0;
		else
			begin
				if(rx_data=="K")// ：的ASCII码
					flag<=1;
				if(rx_data=="\r")//换行的ASCII码
					flag<=0;
			end
	end

always@(negedge rx_int or negedge rst)
	begin
		if(!rst)
			begin
				count<=0;
			end
		else
			begin
				if(flag)
					begin
						if(count>=6)
							count<=0;
						else 
							count<=count+1;
					end
				else
					count<=0;
			end
	end
/***************************************************
*********************读取数据********************
****************************************************/
always@(negedge clk or negedge rst)
	begin
		if(!rst)
			begin
				rec<=8'h30;
			end
		else
			begin
				case(count)
					4'd1,4'd2,4'd3,4'd4:;
					4'd5:rec[7:0]<=rx_data;
					default:rec<=rec;
				endcase
			end
	end
assign data=rec;

assign oSpeaker_io=(rec==8'h31)?1'b1:1'b0;
//assign oSpeaker_io=1'b1;
endmodule
