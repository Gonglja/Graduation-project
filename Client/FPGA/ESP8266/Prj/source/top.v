module top(
				clk_sys,rst_n,							//系统端口
				rx_esp8266,tx_esp8266,				//UART端口---ESP8266
				rx_PC,tx_PC,							//	       ---PC		
				lcd_rs,lcd_en,lcd_rw,lcd_data,	//LCD端口
);
//系统输入输出
input clk_sys,rst_n;

//1602输入输出
output lcd_en,lcd_rs,lcd_rw;
output [7:0]lcd_data;

//串口输入输出
input rx_esp8266,rx_PC;
output tx_esp8266,tx_PC;

//--算式:50_000_000/baud/16
parameter BPS_9600   = 16'd325,
			 BPS_115200 = 16'd27;
wire clk;		//串口时钟
wire [7:0]data;//接收到的陀螺仪数据

//-----------------时钟信号的设定-----------------
clk_set CLK_UART(
					.clk_sys(clk_sys),
					.rst_n(rst_n),
					.baud(BPS_115200),
					.clk(clk)
);

//--------------------UART串口-------------------
//连接PC
//wire [7:0]datasend_PC;
//wire [7:0]datarece_PC;
//assign tx_PC = tx_esp8266;
assign tx_PC = rx_esp8266; 
//assign tx_esp8266 = rx_PC; 

//ESP8266无线模块
wire [7:0]datasend_esp8266;//ESP8266串口发送的数据
wire [7:0]datarece_esp8266;//ESP8266串口接收的数据
wire Sig;
wire rx_int_esp8266;

//发送指定代码 使esp8266处于工作中
esp8266_encode encode(
					.Clk(clk),
					.Rst_n(rst_n),
					.Sig(Sig),
					.Data_send(datasend_esp8266[7:0])
);
uart_tx module_tx_esp8266(
					.clk(clk),
					.rst_n(rst_n),
					.data_wr(tx_esp8266),
					.wrsig(Sig),
					.datain(datasend_esp8266[7:0])					
);
//esp8266接收数据 并对数据进行解码
wire [23:0] datarece;//转换后的数据（对接收的数据进行转换）	
uart_rx module_rx_esp8266(
					.clk(clk),
					.rst_n(rst_n),
					.rx_int(rx_int_esp8266),
					.data_rd(rx_esp8266),
					.dataout(datarece_esp8266)
);
esp8266_decode decode(
					.rx_int(rx_int_esp8266),
					.rx_data(datarece_esp8266),
					.clk(clk_sys),
					.rst(rst_n),
					.data(datarece)
);


//-------------------ESP8266数据处理---------------------
wire [12:0]SetAngleOut;
ReceiveMessage_control UU(
					.Clk(clk),
					.Rst_n(rst_n),
					.ReceiveMessage(datarece),
					.SetAngleOut(SetAngleOut)
);


//--------------------LCD1602显示----------------------
lcd1602 U5( 	.clk(clk_sys),    //50M  20ns
					.rst_n(rst_n),  
					.lcd_rs(lcd_rs),//  1:write data  0:write commmand 
					.lcd_en(lcd_en),//  1:使能
					.lcd_rw(lcd_rw),//  1:read data   0:write data
					.lcd_data(lcd_data),//数据口

//传入要显示的字符
//第一行
					.data0("C"), 
					.data1("A"), 
					.data2(":"),
					.data3(" "), 
					.data4(" "),
					.data5(" "), 
					.data6(" "), 
					.data7("S"),
					.data8("A"), 
					.data9(":"),
					.data10(" "),
					.data11(" "),
					.data12(" "),
					.data13(" "),
					.data14(" "), 
					.data15(" "),
//第二行
					.data16("R"),
					.data17(":"),
					.data18(" "),
					.data19(" "),
					.data20(" "),
					.data21(" "),
					.data22("A"),
					.data23(":"),
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
