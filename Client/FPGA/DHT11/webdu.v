module webdu(clk,Data,reset,lcd_rs,lcd_en,lcd_rw,lcd_data);
input clk,reset;
inout Data;
//1602输入输出
output lcd_en,lcd_rs,lcd_rw;
output [7:0]lcd_data;

wire[39:0] data;  
wire clkout; 
DVF dvf(clk,clkout);
wire read_flag;
temp Temp(		
					.clk(clkout),
					.nRST(reset),
					.Data(Data),
					.data1(data),
					.read_flag(read_flag)
);

//--------------------LCD1602显示----------------------
lcd1602 UU( 	.clk(clk),    //50M  20ns
					.rst_n(reset),  
					.lcd_rs(lcd_rs),//  1:write data  0:write commmand 
					.lcd_en(lcd_en),//  1:使能
					.lcd_rw(lcd_rw),//  1:read data   0:write data
					.lcd_data(lcd_data),//数据口

//传入要显示的字符
//第一行
					.data0("H"), 
					.data1(":"), 
					.data2(8'h30+data[39:32]/100),
					.data3(8'h30+data[39:32]%100/10),
					.data4(8'h30+data[39:32]%10), 
					//.data5(8'h30+data[31:24]/100),
					//.data6(8'h30+data[31:24]%100/10),
					//.data7(8'h30+data[31:24]%10), 
					.data5(" "), 
					.data6(" "),
					.data7(" "),
					.data8(" "), 
					.data9(" "),
					.data10(" "),
					.data11(" "),
					.data12(" "),
					.data13(" "),
					.data14(" "), 
					.data15(" "),
//第二行
					.data16("T"),
					.data17(":"),
					.data18(8'h30+data[23:16]/100),
					.data19(8'h30+data[23:16]%100/10),
					.data20(8'h30+data[23:16]%10),
					.data21("."),
					//.data21(8'h30+data[15:8]/100),
					//.data22(8'h30+data[15:8]%100/10),
					.data22(8'h30+data[15:8]%10),
					.data23(" "),
					.data24(" "),
					.data25(" "),
					.data26(" "),
					.data27(" "),
					.data28(" "),
					.data29(" "),
					.data30(" "),
					.data31(" ")
);


endmodule
