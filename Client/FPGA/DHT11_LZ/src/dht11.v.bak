//==========================================================================
//company   :NanJingUniversity JiLing College
//Filename  :dht11.v
//modulename:dht11
//Author    :moyunjie
//Date	    :2016-1-13
//Function  :温湿度计dht11的数据采集，采集间隔1s
//==========================================================================
module dht11(
						i_clk,
						i_rst_n,
						io_data,
						o_temp,
						o_humi
							);

input i_clk;//50mhz
input i_rst_n;//低电平复位
inout io_data;//数据端口
output reg [7:0]o_temp;//输出温度
output reg [7:0]o_humi;//输出湿度
reg o_data;//输出数据



reg [39:0]get_data;//dht11获取的数据
reg [5:0]data_num;//获取数据的位数
reg[3:0]crt_state;//三段状态机
reg [3:0]next_state;
parameter idle		= 4'b0001;//空闲状态
parameter init		= 4'b0010;//主机请求复位状态
parameter ans 		= 4'b0100;//从机应答
parameter rd_data	= 4'b1000;//接受数据
/////////============状态机
always@(posedge i_clk or negedge i_rst_n )
				if(!i_rst_n)
						crt_state<=idle;
				else
						crt_state<=next_state;


reg data_sam1;//输入采样1
reg data_sam2;//输入采样2

reg data_pluse;//检测输入上升沿脉冲
always@(posedge i_clk )
begin
	data_sam1<=io_data;
	data_sam2<=data_sam1;
	data_pluse<=(~data_sam2)&data_sam1;
end
reg[26:0] cnt_1s;//1s计数器  
always@(posedge i_clk or negedge i_rst_n )
	if(!i_rst_n)
		cnt_1s<=27'd0;	
	else if(cnt_1s==27'd49999999)
		cnt_1s<=27'd0;
	else
		cnt_1s<=cnt_1s+1'b1;
/////////============状态机	
always@( *) 
		case(crt_state)
				idle:if(cnt_1s==27'd49999999)//1s后开始工作
								next_state=init;
							else
								next_state=crt_state;
				
				init:if(cnt_1s>=27'd1002000 )//20ms+40us
								next_state=ans;
							else
								next_state=crt_state;
				
				ans:	if(data_pluse)//检测到上升沿
								next_state=rd_data;
							else
								next_state=crt_state;
				
				rd_data:if(data_num==6'd40)//收到40位数据
									next_state=idle;
								else
									next_state=crt_state;
				default:next_state=idle;
		endcase
		
reg [12:0]cnt_40us;//40us计数器
reg send_indi;//主机输出指示
reg r_hold;//维持40us
always@(posedge i_clk )
	if(crt_state[1] && (cnt_1s<=27'd1000000))//发送20ms（>18ms）低电平
		begin
			o_data<=1'b0;
			send_indi<=1'b1;
		end
	else if(crt_state[1])//等待40us，电平拉高
		begin
			o_data<=1'b1;
			send_indi<=1'b0;
		end
	else if(crt_state[2] & data_pluse)//检测到dht拉高
		begin
			data_num<=6'd0;
		end
	else if(crt_state[3] & (data_pluse | r_hold))//接受数据
				begin
					r_hold<=1'b1;
					cnt_40us<=cnt_40us+1'b1;
					if(cnt_40us==12'd2000)//检测高低电平等待40us（28<40<70）再检测高低电平
						begin
							r_hold<=1'b0;
							if(io_data)
									get_data<={get_data[38:0],1'b1};
							else
								   get_data<={get_data[38:0],1'b0}; 
							cnt_40us<=12'd0;
							data_num<=data_num+1'b1;
						end
				end
	else
		begin
			if(data_num==6'd40)//温湿度赋值
				begin
					o_humi<=get_data[39:32];
					o_temp<=get_data[23:16];
				end
		end		

assign io_data =send_indi ? o_data : 1'bz;//双向端口

endmodule
			 
		
		
		
		

