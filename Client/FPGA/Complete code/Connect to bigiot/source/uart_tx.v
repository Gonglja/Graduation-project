module uart_tx(
					clk,
					rst_n,
					data_wr,
					wrsig,
					datain
					
);
input clk;
input rst_n;
input wrsig;
input [7:0]datain;
output  data_wr;
reg data_wr;
//reg [7:0]datain;
reg idle;


//检测上升沿
reg wrsigbuf,wrsigrise,send;
always@(posedge clk)begin
	wrsigbuf <= wrsig;
	wrsigrise <= (~wrsigbuf)&wrsig;
end

//启动串口发送程序
reg [7:0]clk_count;
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)
			send <= 1'b0;
	else if(wrsigrise&&(~idle))begin
			send	<= 1'b1;
		end
	else if(clk_count == 8'd152)begin
			send	<= 1'b0;
		end

end

//串口发送程序
always@(posedge clk	or negedge rst_n)begin
	if(!rst_n)begin
			clk_count <= 8'd0;
			idle <= 1'b0;
			data_wr <= 1'b0;
		end
	else if(send == 1'b1)begin
			case(clk_count)
					8'd0:begin
								idle <= 1'b1;
								data_wr <= 1'b0;
								clk_count <= clk_count + 8'd1;
						  end
					8'd24:begin//16*(0+1)+8 发送第0位数据
								idle <= 1'b1;
								data_wr <=datain[0];
								clk_count <= clk_count + 8'd1;
						   end
					8'd40:begin//16*(1+1)+8 发送第1位数据
								idle <= 1'b1;
								data_wr <=datain[1];
								clk_count <= clk_count + 8'd1;
						   end
					8'd56:begin//16*(2+1)+8 发送第2位数据
								idle <= 1'b1;
								data_wr <=datain[2];
								clk_count <= clk_count + 8'd1;
						   end
					8'd72:begin//16*(3+1)+8 发送第3位数据
								idle <= 1'b1;
								data_wr <=datain[3];
								clk_count <= clk_count + 8'd1;
						   end
					8'd88:begin//16*(4+1)+8 发送第4位数据
								idle <= 1'b1;
								data_wr <=datain[4];
								clk_count <= clk_count + 8'd1;
						   end
					8'd104:begin//16*(5+1)+8 发送第5位数据
								idle <= 1'b1;
								data_wr <=datain[5];
								clk_count <= clk_count + 8'd1;
						   end
					8'd120:begin//16*(6+1)+8 发送第6位数据
								idle <= 1'b1;
								data_wr <=datain[6];
								clk_count <= clk_count + 8'd1;
						   end
					8'd136:begin//16*(7+1)+8 发送第7位数据
								idle <= 1'b1;
								data_wr <=datain[7];
								clk_count <= clk_count + 8'd1;
						   end
					8'd152:begin//16*(8+1)+8 发送停止位
								idle <= 1'b1;
								data_wr <= 1'b1;
								clk_count <= clk_count + 8'd1;
						   end
					8'd160:begin//16*(8+1)+8 一帧发送结束
								idle <= 1'b0;
								data_wr <= 1'b1;
								clk_count <= clk_count + 8'd1;
						   end
					default:
								clk_count <= clk_count + 8'd1;
				endcase
		end
	else begin
			idle <= 1'b0;
			data_wr <= 1'b1;
			clk_count <= 8'd0;
		end
end

endmodule
