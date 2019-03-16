module top(
				clk_sys,rst_n,							//系统端口
				rx_esp8266,tx_esp8266,				//UART端口---ESP8266
				rx_PC,tx_PC,							//	       ---PC	
			   dht11_io,								//DHT11数据口	
				ds18b20_io,								//DS18B20数据口
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

//DHT11输入输出
inout dht11_io;

//DS18B20输入输出
inout ds18b20_io;

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
assign tx_PC = tx_esp8266;
//assign tx_PC = rx_esp8266; 
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
					.inputData(dht11_data_out),
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
//--------------------时钟分频----------------------------
wire clk_2Mhz;
DVF            dvf(
					.CLK_50Mhz(clk_sys),
					.clkout(clk_2Mhz)
);
//--------------------DHT11采集---------------------------
wire[39:0] dht11_data; 
wire[31:0] dht11_data_out;

wire[7:0]dht11_temp_0;
wire[7:0]dht11_temp_1;
wire[7:0]dht11_temp_2;
wire[7:0]dht11_temp_3;

dht11 DHT11(		
					.clk(clk_sys),
					.nRST(rst_n),
					.Data(dht11_io),
					.data1(dht11_data)
);
assign dht11_temp_0 = dht11_data[23:16]%100/10;
assign dht11_temp_1 = dht11_data[23:16]%10;
assign dht11_temp_2 = dht11_data[15:0]%10;
assign dht11_data_out[31:0]={8'h54,dht11_temp_0,dht11_temp_1,dht11_temp_2};
//assign dht11_data_out[31:0]={8'h54,,dht11_data[23:16]%100/10,dht11_data[23:16]%10};

//--------------------DS18B20采集------------------------
wire [11:0]ds18b20_data;
reg clkenable;
reg [7:0]cccccccc;
always @(posedge clk_sys or negedge rst_n)begin
	if(!rst_n)begin
		clkenable <= 0; 
		cccccccc  <= 8'd0;
	end
	else if(cccccccc == 8'd100)begin
		clkenable <= 1;
		cccccccc  <= 8'd0;
	end
	else
		clkenable <= 0;
		cccccccc  <= cccccccc+1'b1;
end

wire ds18b20_temp_0;
wire ds18b20_temp_1;
wire ds18b20_temp_2;
wire ds18b20_temp_3;
wire ds18b20_temp_4;

ds18b20 ds18b20(
					.nReset(rst_n),
					.ClkEnable(clkenable),
					.clk(clk_2Mhz),
					.data(ds18b20_data),
					.icdata(ds18b20_io)
);
assign ds18b20_temp_0 = ds18b20_data[11:0]*625%10;
assign ds18b20_temp_1 = ds18b20_data[11:0]*625%100/10;
assign ds18b20_temp_2 = ds18b20_data[11:0]*625%1000/100;
assign ds18b20_temp_3 = ds18b20_data[11:0]*625%10000/1000;
assign ds18b20_temp_4 = ds18b20_data[11:0]*625%100000/10000;
//--------------------LCD1602显示----------------------
lcd1602 U5( 	.clk(clk_sys),    //50M  20ns
					.rst_n(rst_n),  
					.lcd_rs(lcd_rs),//  1:write data  0:write commmand 
					.lcd_en(lcd_en),//  1:使能
					.lcd_rw(lcd_rw),//  1:read data   0:write data
					.lcd_data(lcd_data),//数据口

//传入要显示的字符
//第一行
					.data0("H"), 
					.data1(":"), 
					.data2(8'h30+dht11_data[39:32]/100),
					.data3(8'h30+dht11_data[39:32]%100/10), 
					.data4(8'h30+dht11_data[39:32]%10),
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
					.data18(8'h30+dht11_temp_0),
					.data19(8'h30+dht11_temp_1),
					.data20("."),
					.data21(8'h30+dht11_temp_2),
					.data22(" "),
					.data23(" "),
					.data24(" "),
					.data25(" "),
					.data26(8'h30+ds18b20_temp_4),
					.data27(8'h30+ds18b20_temp_3),
					.data28(8'h30+ds18b20_temp_2),
					.data29(8'h30+ds18b20_temp_1),
					.data30(8'h30+ds18b20_temp_0),
					.data31(" ")

);


endmodule
