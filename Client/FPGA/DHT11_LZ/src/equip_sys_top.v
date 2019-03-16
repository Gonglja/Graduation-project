`timescale 1ns/1ps

module equip_sys_top
	(
		input 			clk_50m		,
		input			rst_n		,
		output			LCD_RS		, 
		output			LCD_E		, 
		output			LCD_RW		, 
		output	[7:0]	LCD_D		,
		inout			dht11_io	
	);
	
	
	wire			data_rdy		;
	reg 			dht11_rst_n		;
	
		
	wire [15:0] 	dht11_temp_dis		;
	wire [15:0] 	dht11_humidity_dis	;
	
	reg [31:0] delay_1s;
	
	
	always @(posedge clk_50m or negedge rst_n) begin
		if(!rst_n) begin
			dht11_rst_n <= 1'd0;
			delay_1s <= 32'd0;
		end
		else begin
			if(delay_1s >= 59_999_999)begin
				delay_1s <= 32'd0;
				dht11_rst_n <= 1'd0;
			end
			else begin
				delay_1s <= delay_1s + 1'd1;
				dht11_rst_n <= 1'd1;
			end
		end
	end
	
	dht11 dht11
	(
		.i_clk		(clk_50m),
		.i_rst_n	(dht11_rst_n),
		.io_data	(dht11_io),
		.o_temp		(dht11_temp_dis),
		.o_humi		(dht11_humidity_dis)
	);

	lcd1602 lcd1602         //lcd1602例化
	( 
		.clk(clk_50m),                //时钟50Mhz    
		.rst_n(rst_n),              //按键初始化
		.lcd_rs(LCD_RS),           
		.lcd_rw(LCD_RW),       
		.lcd_en(LCD_E),   
		.lcd_data(LCD_D),
	///////////////////////////////第一行////////////////////////////////////////////	
		.data0	("T"),
		.data1	(":"),
		.data2	(8'h30+dht11_temp_dis[15:8]/100		),
		.data3	(8'h30+dht11_temp_dis[15:8]%100/10	),
		.data4	(8'h30+dht11_temp_dis[15:8]%10		),
		.data5	("."),
		.data6	(8'h30+dht11_temp_dis[7:0]/100		),
		.data7	(8'h30+dht11_temp_dis[7:0]/100/10	),
		.data8   (8'h30+dht11_temp_dis[7:0]%10		),
		.data9	(" "),
		.data10	(" "),
		.data11	(" "),
		.data12	(" "),
		.data13	(" "),
		.data14	(" "),
		.data15	(" "),
	///////////////////////////////第二行//////////////////////////////////////////////////	
		.data16	("H"),
		.data17	(":"),
		.data18	(8'h30+dht11_humidity_dis[15:8]/100		),
		.data19	(8'h30+dht11_humidity_dis[15:8]%100/10	),
		.data20	(8'h30+dht11_humidity_dis[15:8]%10		),
		.data21	("."),
		.data22	(8'h30+dht11_humidity_dis[7:0]/100		),
		.data23	(8'h30+dht11_humidity_dis[7:0]%100/10	),
		.data24	(8'h30+dht11_humidity_dis[7:0]%10	),
		.data25	(" "),
		.data26	(" "),
		.data27	(" "),
		.data28	(" "),
		.data29	(" "),
		.data30	(" "),
		.data31	(" ")
	);
	
	
endmodule