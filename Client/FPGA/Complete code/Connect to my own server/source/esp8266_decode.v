module esp8266_decode(rx_int,rx_data,clk,rst,data);

input clk,rst,rx_int;
input [7:0] rx_data;

output [23:0]data;

reg[3:0] count;
//9*4  48-36=12  3位数据
reg [23:0]w;
reg flag;

//`define _A 8'h41

always@(posedge clk or negedge rst)
	begin
		if(!rst)
			flag<=0;
		else
			begin
				if(rx_data==8'h3A)// ：的ASCII码
					flag<=1;
				if(rx_data==8'h0d)//换行的ASCII码
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
						if(count>=4)
							count<=0;
						else 
							count<=count+1;
					end
				else
					count<=0;
			end
	end
/***************************************************
*********************读取3个数据********************
****************************************************/
always@(negedge clk or negedge rst)
	begin
		if(!rst)
			begin
				w<=8'h20;
			end
		else
			begin
				case(count)
					4'd1:w[23:16]<=rx_data;
					4'd2:w[15:8]<=rx_data;
					4'd3:w[7:0]<=rx_data;
					default:w<=w;
				endcase
			end
	end
assign data=w;


endmodule
