	`timescale 1ns / 1ns
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:    12:29:50 08/12/08
// Design Name:    
// Module Name:    i2c_code
// Project Name:   
// Target Device:  
// Tool versions:  
// Description:
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
module i2c(clk,rst_n,scl,sda,final_data,led,current_state,temp);

input clk;	// 50M
input rst_n;	//复位信号，低有效
output scl,led,temp;	// 24C02的时钟端口
inout sda;	// 24C02的数据端口
//output [7:0]byte_data2;	//
output [7:0]final_data,current_state;
		//分频部分
reg[2:0] cnt;	//cnt=0:scl上升沿，cnt=1:scl高电平中间，cnt=2:scl下降沿，cnt=3:scl低电平中间
reg[30:0] cnt_delay;	//5000循环计数
reg scl_r;	//时钟脉冲寄存器
reg terminate;
reg [15:0]clock;
reg led;
always @ (posedge clk or negedge rst_n)
	if(!rst_n) begin 
	cnt_delay <= 13'd0;
//	led<=1'b0;
	clock<=16'd0; end
	else if(cnt_delay==30'd5000) begin
	cnt_delay <= 30'd0;	//产生iic所需要的时钟
	    if(clock==16'd10000) begin
//			led<=~led;
			clock<=16'd0;end
		else
			clock<=clock+1'b1;end 
	else cnt_delay <= cnt_delay+1'b1;

reg[2:0] former_cnt;
always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin 
       cnt <= 2'd0;
    end
	else begin
		case (cnt_delay)
			30'd1249:	begin 
			            cnt <= 3'd1;
			            former_cnt<=3'b0;
			            end
			30'd1250:   former_cnt<=3'd1;
			30'd2499:	begin
			            cnt <= 3'd2;
			            end
			30'd2500:   former_cnt<=3'd2;
			30'd3749:	cnt <= 3'd3;
			30'd3750:   former_cnt<=3'd3;
			30'd4999:	begin
			            cnt <= 3'd0;
			            end
			30'd5000:   former_cnt<=3'd0;
			default: cnt <= 3'd5;
			endcase
		end
end

always @ (cnt or rst_n) begin	//posedge clk or negedge rst_n
	if(!rst_n) scl_r <= 1'b0;
	else if(cnt==3'd0) scl_r <= 1'b1;
   else if(cnt==3'd2) scl_r <= 1'b0;
//	else scl_r <= scl_r;
end

assign scl = scl_r ? 1'b1:1'b0;	//产生iic所需要的时钟
//---------------------------------------------
		

reg[7:0] device_add;	//最低bit：1--读，0--写
parameter device_read = 8'b1001_0011;//需要写入PCF8591的地址
reg[7:0] byte_add;	// 写入地址
reg[7:0] byte_data1;	//写入的数据
reg[7:0]	byte_data2;	//读出的数据
//---------------------------------------------
		//读、写时序
parameter IDLE 	= 8'b00000001;
parameter START1  = 8'b00000010;
parameter ADD1 	= 8'b00000100;
parameter ACK1 	= 8'b00001000;
parameter ACK3    = 8'b00010000;
parameter DATA 	= 8'b00100000;
parameter ACK2	   = 8'b01000000;
parameter STOP 	= 8'b10000000;

reg[7:0] current_state,next_state;
reg sda_r,sda_link,temp;	//输出数据寄存器
reg[3:0] num;
//reg ack_bit;	//响应位寄存器

always @ (next_state or rst_n)  //posedge clk or negedge rst_n
	if(!rst_n) current_state <= IDLE;
	else current_state <= next_state;

reg hold;	
reg [7:0]final_data;
always @ (posedge clk or negedge rst_n) begin	  
	if(!rst_n) begin

			next_state <= IDLE;
			final_data<=8'b00000000;
			num <= 4'd0;
			byte_data2 <= 8'b1010_1010;
			device_add <= 8'b1001_0011;
			led<=1'b0;			
    end
	else 	  
		case (current_state)
			IDLE:	begin
					sda_link <= 1'b1;
					if(cnt==3'd3) begin	  
						device_add <=8'b1001_0011;
						next_state <= START1;
						sda_link <= 1'b1;
						sda_r <= 1'b1;
						temp<=1'b1;
						end
					else next_state <= IDLE;
				end
			START1: begin////发出启动信号
					if(cnt==3'd1) begin
						sda_r <= 1'b0;
						next_state <= ADD1;
						num <= 4'd0;
						end
					else next_state <= START1; 
				end
			ADD1:	begin//向PCF8591传送地址字
				
					if(num<=4'd8) begin
						next_state <= ADD1;
					if(former_cnt==3'd2) begin
					if(cnt==3'd3) begin
							num <= num+1'b1;
							sda_r <= device_add[7];
							end
					else next_state <= ADD1;
					end
					else if(former_cnt==3'd3) begin
						if(cnt==3'd0) begin
							device_add <= {device_add[6:0],device_add[7]};
							end
						else next_state <= ADD1;
					 	end 
				end
					else if((num==4'd9) && (cnt==3'd3)) begin	
						device_add <= {device_add[6:0],device_add[7]};//
//						num <= 4'd0;
						hold<=1'b0;
						sda_link <= 1'b0;		//sda置为高阻态
						next_state <= ACK1;
//						temp<=1'b1;
						end
					else next_state <= ADD1;
				end
			 
			ACK1:	begin
//				    led<=1'b1;
					if(cnt==3'd1) begin
					temp<=sda;////检验PCF8591的应答，如有应答sda应为低电平。但sda未被拉低，所以程序仅进行至此
					next_state<=ACK1; end
					else
					if((cnt==3'd2)&&(temp==0)) begin 
						next_state <= ACK1;
						hold<=1'b1;
						end	
					else if((cnt==3'd3)&&(hold==1))	begin
						next_state<=DATA;
						num<=1'b0; end
					else next_state <= ACK1; 
				end
			
			DATA:	begin   ////开始接收PCF8591传来的一个字节
						led<=1'b1;
						hold<=1'b0;
							if(num<=4'd7) begin
								next_state  <= DATA;
							if(former_cnt==3'd0) begin
								if(cnt==3'd1) begin	
									num <= num+1'b1;
									byte_data2[7] <= sda;
									end
								else next_state  <= DATA;
							end
						    else if(former_cnt==3'd1) begin
								if(cnt==3'd2) begin
								byte_data2 <= {byte_data2[6:0],byte_data2[7]};
							 		end
							    else next_state  <= DATA;
								end
						
							 end
							else if((cnt==3'd3) && (num==4'd8)) begin
								byte_data2 <= {byte_data2[6:0],byte_data2[7]};
							    next_state<= ACK3;
								sda_r <= 1'b1;
						        sda_link <= 1'b1;
		
								end
							else next_state <= DATA;
						end
	
			ACK3: begin //非应答
					if(cnt==3'd2) begin
						next_state<=ACK3;
						hold<=1'b1;
						end
					else if((cnt==3'd3)&&(hold==1'b1)) begin
						next_state <= STOP;	
						final_data<=byte_data2;	
						sda_r<=1'b0;
						hold<=1'b0;				
						end
				end
			
			STOP:	begin
					if(cnt==3'd1) begin
						sda_r <= 1'b1;
						hold<=1'b1;
						end
					else if((cnt==3'd3) && sda_link&&hold) 
					    sda_link <= 1'b0; //转换完毕
					else next_state <= STOP;
				end
			default: ;
			endcase
end

assign sda = sda_link ? sda_r:1'bz;


endmodule


