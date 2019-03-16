module uart_rx(
					clk,
					rst_n,
					rx_int,
					data_rd,
					dataout
					
);
input clk;
input rst_n;
input  data_rd;
output [7:0]dataout;
reg [7:0]dataout;
reg [7:0]dataout1;
reg idle;
output rx_int;	//接收数据中断信号,接收到数据期间始终为高电平
reg rx_int;		//接收数据中断信号,接收到数据期间始终为高电平
//检测下降沿
reg rxbuf,rxfall,receive;
always@(posedge clk)begin
	rxbuf <= data_rd;
	rxfall <= rxbuf&(~data_rd);
end

//启动串口接收程序
reg [7:0]clk_count;
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
			receive <= 1'b0;
			rx_int <= 1'b0;
		end
	else if(rxfall&&(~idle))begin
			receive <= 1'b1;
			rx_int <= 1'b1;			//接收数据中断信号使能
		end
	else if(clk_count == 8'd152)begin
			receive <= 1'b0;
			rx_int <= 1'b0;			//接收数据中断信号关闭
		end

end

//串口接收程序
reg frame_end;
always@(posedge clk	or negedge rst_n)begin
	if(!rst_n)begin
			clk_count <= 8'd0;
			idle <= 1'b0;
		end
	else if(receive == 1'b1)begin
			case(clk_count)
					8'd0:begin
								idle <= 1'b1;
								clk_count <= clk_count + 8'd1;
						  end
					8'd24:begin//16*(0+1)+8 接收第0位数据
								idle <= 1'b1;
								dataout1[0] <= data_rd;
								clk_count <= clk_count + 8'd1;
						   end
					8'd40:begin//16*(1+1)+8 接收第1位数据
								idle <= 1'b1;
								dataout1[1] <= data_rd;
								clk_count <= clk_count + 8'd1;
						   end
					8'd56:begin//16*(2+1)+8 接收第2位数据
								idle <= 1'b1;
								dataout1[2] <= data_rd;
								clk_count <= clk_count + 8'd1;
						   end
					8'd72:begin//16*(3+1)+8 接收第3位数据
								idle <= 1'b1;
								dataout1[3] <= data_rd;
								clk_count <= clk_count + 8'd1;
						   end
					8'd88:begin//16*(4+1)+8 接收第4位数据
								idle <= 1'b1;
								dataout1[4] <= data_rd;
								clk_count <= clk_count + 8'd1;
						   end
					8'd104:begin//16*(5+1)+8 接收第5位数据
								idle <= 1'b1;
								dataout1[5] <= data_rd;
								clk_count <= clk_count + 8'd1;
						   end
					8'd120:begin//16*(6+1)+8 接收第6位数据
								idle <= 1'b1;
								dataout1[6] <= data_rd;
								clk_count <= clk_count + 8'd1;
						   end
					8'd136:begin//16*(7+1)+8 接收第7位数据
								idle <= 1'b1;
								dataout1[7] <= data_rd;
								clk_count <= clk_count + 8'd1;
						   end
					8'd152:begin//16*(8+1)+8 接收第8位数据
								idle <= 1'b1;
								if(1'b1==data_rd)
									frame_end <= 1'b1;
								else 
									frame_end <= 1'b0;
								clk_count <= clk_count + 8'd1;
						   end
					default:
								clk_count <= clk_count + 8'd1;
				endcase
		end
	else begin
			idle <= 1'b0;
			clk_count <= 8'd0;
			if(frame_end==1'b1)
					dataout <= dataout1;
			else 
					dataout <= dataout;
	end
end

endmodule
