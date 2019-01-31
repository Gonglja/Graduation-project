module LCD12864
	( 
		input CLK,RST_N,
		output reg LCD_RS, output LCD_E, output reg [7:0]LCD_D,
		input [11:0] 
/*******************************************第一行变量**************************************************/
		linex_dat0,linex_dat1,linex_dat2,linex_dat3,linex_dat4,linex_dat5,
		linex_dat6,linex_dat7,linex_dat8,linex_dat9,linex_dat10,
		linex_dat11,linex_dat12,linex_dat13,linex_dat14,linex_dat15,
/*******************************************第二行变量**************************************************/
		liney_dat0,liney_dat1,liney_dat2,liney_dat3,liney_dat4,liney_dat5,
		liney_dat6,liney_dat7,liney_dat8,liney_dat9,liney_dat10,
		liney_dat11,liney_dat12,liney_dat13,liney_dat14,liney_dat15,
/*******************************************第三行变量**************************************************/
		linez_dat0,linez_dat1,linez_dat2,linez_dat3,linez_dat4,linez_dat5,
		linez_dat6,linez_dat7,linez_dat8,linez_dat9,linez_dat10,
		linez_dat11,linez_dat12,linez_dat13,linez_dat14,linez_dat15,
/*******************************************第四行变量**************************************************/
		linew_dat0,linew_dat1,linew_dat2,linew_dat3,linew_dat4,linew_dat5,
		linew_dat6,linew_dat7,linew_dat8,linew_dat9,linew_dat10,
		linew_dat11,linew_dat12,linew_dat13,linew_dat14,linew_dat15
	); 

reg CLK_LCD; //LCD时钟信号 
reg [23:0]cnt; 

// CLK频率为50MHz, 产生LCD时钟信号, 10Hz 
always @(posedge CLK or negedge RST_N) 
begin 
    if (!RST_N) 
    begin 
cnt <= 24'b0; 
CLK_LCD <= 0; 
    end 
    else if(cnt == 24999) 
    begin 
cnt <= 0; 
CLK_LCD <= ~CLK_LCD; 
    end 
    else 
cnt <= cnt +1'b1; 
end 

reg [8:0] state; //State Machine code 
parameter IDLE  = 9'b00000000; //初始状态，下一个状态为CLEAR 
parameter SETFUNCTION = 9'b00000001; //功能设置：8位数据接口 
parameter SETFUNCTION2 = 9'b00000010; 
parameter SWITCHMODE = 9'b00000100; //显示开关控制：开显示，光标和闪烁关闭 
parameter CLEAR = 9'b00001000; //清屏 
parameter SETMODE      = 9'b00010000; //输入方式设置：数据读写操作后，地址自动加一/画面不动 
parameter SETDDRAM     = 9'b00100000; //设置DDRAM的地址：第一行起始为0x80/第二行为0x90 
parameter WRITERAM     = 9'b01000000; //数据写入DDRAM相应的地址 
parameter STOP = 9'b10000000; //LCD操作完毕，释放其控制 

reg flag; //标志位，LCD操作完毕为0 
reg [7:0]char_cnt; 
reg [7:0]data_disp; 

assign LCD_RW = 1'b0; //没有读操作，R/W信号始终为低电平 
assign LCD_E  = (flag == 1)?CLK_LCD:1'b0; //E信号出现高电平以及下降沿的时刻与LCD时钟相同 

always @(posedge CLK_LCD or negedge RST_N) //只有在写数据操作时，RS信号才为高电平，其余为低电平 
	begin 
		if(!RST_N) 
			LCD_RS <= 1'b0; 
		else if(state == WRITERAM) 
			LCD_RS <= 1'b1; 
		else 
			LCD_RS <= 1'b0; 
	end 

reg [3:0] flag_h;	
	
// State Machine 
always @(posedge CLK_LCD or negedge RST_N) 
begin 
   if(!RST_N) 
		begin 
			state <= IDLE; 
			LCD_D <= 8'bzzzzzzzz; 
			char_cnt <= 5'b0; 
			flag <= 1'b1; 
			flag_h<=0;
		end 
   else begin 
		case(state) 
			 IDLE:begin  
						state <= SETFUNCTION; 
						LCD_D <= 8'bzzzzzzzz;  
					end 
	SETFUNCTION: 
					begin 
						state <= SETFUNCTION2; 
						LCD_D <= 8'h30; // 8-bit 控制界面，基本指令集动作 
					end 
	SETFUNCTION2: 
					begin 
						state <= SWITCHMODE; 
						LCD_D <= 8'h30; // 清屏 
					end 
	 SWITCHMODE: 
					begin 
						state <= CLEAR; 
						LCD_D <= 8'h0c; // 显示开关：开显示，光标和闪烁关闭 
					end 
			CLEAR: 
					begin 
						state <= SETMODE; 
						LCD_D <= 8'h01; 
					end 
		 SETMODE: 
					begin 
						state <= SETDDRAM; 
						LCD_D <= 8'h06; // 输入方式设置: 数据读写后，地址自动加1，画面不动 
					end 
		SETDDRAM: 
					begin 
						state <= WRITERAM; 
						if(char_cnt==0) //如果显示的是第一个字符，则设置第一行的首字符地址 
							LCD_D <= 8'h80; //Line1 
						if(char_cnt==16) //第二次设置时，是设置第二行的首字符地址 
							LCD_D <= 8'h90; //Line2 
						if(char_cnt==32)
							LCD_D <= 8'h88;
						if(char_cnt==48)
							LCD_D <= 8'h98;
					end 
		WRITERAM: 
					begin 
/************************************** 第四行显示16个字符*********************************************/
						if(char_cnt <= 15)                      
							begin 
								flag_h<=1;
								char_cnt <= char_cnt + 1'b1;
								LCD_D <= data_disp; 
								if( char_cnt == 15 ) 
									state <= SETDDRAM; 
								else 
									begin
										state <= WRITERAM;
									end	
							end 
/************************************** 第四行显示16个字符*********************************************/
						else if( char_cnt >= 16 && char_cnt <= 31) 
							begin 
								flag_h<=2;
								char_cnt <= char_cnt + 1'b1;
								LCD_D <= data_disp; 
								state <= WRITERAM;
								if(char_cnt == 31) 
									begin
										state <= SETDDRAM; 
									end
								else  
									begin
										state <= WRITERAM;
									end	
							end 
/************************************** 第四行显示16个字符*********************************************/
						else if( char_cnt >= 32 && char_cnt <= 47)   
							begin 
								flag_h<=3;
								char_cnt <= char_cnt + 1'b1;
								LCD_D <= data_disp; 
								state <= WRITERAM;
								if(char_cnt == 47) 
									begin
										state <= SETDDRAM; 
									end
								else  
									begin
										state <= WRITERAM;
									end	
							end 
/************************************** 第四行显示16个字符*********************************************/
						else if( char_cnt >= 48 && char_cnt <= 64)   
							begin 
								flag_h<=4;
								char_cnt <= char_cnt + 1'b1; 
								LCD_D <= data_disp;	
								state <= WRITERAM;
								if(char_cnt == 64) 
									begin 
										state <= STOP; 
										char_cnt <= 5'b0; 
										flag <= 1'b0; 
									end 
								else  
									begin
										state <= WRITERAM;
									end	
							end
					end 
			 STOP:state <= STOP; 
		 default:state <= IDLE; 
    endcase 
end 
end 

always @(char_cnt) //输出的字符 
	begin 
		case (char_cnt) 
	/************************************** 第一行显示内容*********************************************/
			8'd0: data_disp =  linex_dat0;  
			8'd1: data_disp =  linex_dat1;  
			8'd2: data_disp =  linex_dat2;  
			8'd3: data_disp =  linex_dat3;  
			8'd4: data_disp =  linex_dat4;  
			8'd5: data_disp =  linex_dat5;  
			8'd6: data_disp =  linex_dat6;  
			8'd7: data_disp =  linex_dat7;   
			8'd8: data_disp =  linex_dat8;  
			8'd9: data_disp =  linex_dat9;  
			8'd10: data_disp = linex_dat10;  
			8'd11: data_disp = linex_dat11;  
			8'd12: data_disp = linex_dat12;   
			8'd13: data_disp = linex_dat13;  
			8'd14: data_disp = linex_dat14;  
			8'd15: data_disp = linex_dat15;  
	/************************************** 第二行显示内容*********************************************/
			8'd16: data_disp = liney_dat0; 
			8'd17: data_disp = liney_dat1; 
			8'd18: data_disp = liney_dat2; 
			8'd19: data_disp = liney_dat3; 
			8'd20: data_disp = liney_dat4; 
			8'd21: data_disp = liney_dat5; 
			8'd22: data_disp = liney_dat6; 
			8'd23: data_disp = liney_dat7; 
			8'd24: data_disp = liney_dat8; 
			8'd25: data_disp = liney_dat9; 
			8'd26: data_disp = liney_dat10; 
			8'd27: data_disp = liney_dat11; 
			8'd28: data_disp = liney_dat12; 
			8'd29: data_disp = liney_dat13; 
			8'd30: data_disp = liney_dat14; 
			8'd31: data_disp = liney_dat15; 
	/************************************** 第三行显示内容*********************************************/		
			8'd32: data_disp = linez_dat0; 
			8'd33: data_disp = linez_dat1; 
			8'd34: data_disp = linez_dat2; 
			8'd35: data_disp = linez_dat3; 
			8'd36: data_disp = linez_dat4; 
			8'd37: data_disp = linez_dat5; 
			8'd38: data_disp = linez_dat6; 
			8'd39: data_disp = linez_dat7; 
			8'd40: data_disp = linez_dat8; 
			8'd41: data_disp = linez_dat9; 
			8'd42: data_disp = linez_dat10; 
			8'd43: data_disp = linez_dat11; 
			8'd44: data_disp = linez_dat12; 
			8'd45: data_disp = linez_dat13; 
			8'd46: data_disp = linez_dat14; 
			8'd47: data_disp = linez_dat15; 
	/************************************** 第四行显示内容*********************************************/
			8'd48: data_disp = linew_dat0; 
			8'd49: data_disp = linew_dat1; 
			8'd50: data_disp = linew_dat2; 
			8'd51: data_disp = linew_dat3; 
			8'd52: data_disp = linew_dat4; 
			8'd53: data_disp = linew_dat5; 
			8'd54: data_disp = linew_dat6; 
			8'd55: data_disp = linew_dat7; 
			8'd56: data_disp = linew_dat8; 
			8'd57: data_disp = linew_dat9; 
			8'd58: data_disp = linew_dat10; 
			8'd59: data_disp = linew_dat11; 
			8'd60: data_disp = linew_dat12; 
			8'd61: data_disp = linew_dat13; 
			8'd62: data_disp = linew_dat14; 
			8'd63: data_disp = linew_dat15; 
			default :   data_disp =  8'd0; 
		endcase 
	end 

endmodule 