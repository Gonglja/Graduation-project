/******************************************************
******************液晶动态显示***************************
****************第一行显示按键值**************************
****************第二行显示 0-99**************************
********************************************************/
module adc_det_project(
				input 			clk				,
				input 			rst				,
				output 			lcd_rs			,
				output 			lcd_en			,
				output 			lcd_rw			,
				output [7:0]	lcd_data		,
				
				input			tlc1543_data	,	
				input			tlc1543_eoc 	,
				output			tlc1543_clk 	,
				output			tlc1543_cs_n	,
				output			tlc1543_addr
			);

wire [3:0] angle_g,angle_s,angle_b,angley_g,angley_s,angley_b,anglez_g,anglez_s,anglez_b;
wire[3:0] wx_g,wx_s,wx_b,wy_g,wy_s,wy_b,wz_g,wz_s,wz_b;

wire [ 9:0] adc_data_out_ch1;
wire [ 9:0] adc_data_out_ch2;
wire [15:0] v_data_out;
 
	tlc1543_top tlc1543_top 
	(
		.clk_50m         				(clk				)
		,.rst_n             			(rst				)
		//tlc1543_data_set intf	
		,.adc_data_out_ch1				(adc_data_out_ch1	)	//output	[9:0]  	adc_data_out_ch1 
		,.adc_data_out_ch2				(adc_data_out_ch2	)	//output	[9:0]  	adc_data_out_ch2 
		//tlc1543_spi intf                                                                           
		,.tlc1543_data					(tlc1543_data		)	//input 			tlc1543_data     
		,.tlc1543_eoc 					(tlc1543_eoc 		)	//input 			tlc1543_eoc      
		,.tlc1543_clk 					(tlc1543_clk 		)	//output			tlc1543_clk      
		,.tlc1543_cs_n					(tlc1543_cs_n		)	//output			tlc1543_cs_n     
		,.tlc1543_addr					(tlc1543_addr		)	//output			tlc1543_addr    
   );
   
   // assign v_data_out = adc_data_out*5000/1024 ;

	lcd1602 lcd1602         //lcd1602例化
	( 
	.clk(clk),                //时钟50Mhz    
	.rst_n(rst),              //按键初始化
	.lcd_rs(lcd_rs),           
	.lcd_rw(lcd_rw),       
	.lcd_en(lcd_en),   
	.lcd_data(lcd_data),
///////////////////////////////第一行////////////////////////////////////////////	
	.data0	("V"),
	.data1	("1"),
	.data2	(":"),
	.data3	(8'h30+adc_data_out_ch1/1000			),
	.data4	(8'h30+adc_data_out_ch1%1000/100		),
	.data5	(8'h30+adc_data_out_ch1%1000%100/10		),
	.data6	(8'h30+adc_data_out_ch1%10				),
	.data7	(" "),
	.data8	(" "),
	.data9	(" "),
	.data10	(" "),
	.data11	(" "),
	.data12	(" "),
	.data13	(" "),
	.data14	(" "),
	.data15	(" "),
///////////////////////////////第二行//////////////////////////////////////////////////	
	.data16	("V"),
	.data17	("2"),
	.data18	(":"),
	.data19	(8'h30+adc_data_out_ch2/1000		),
	.data20	(8'h30+adc_data_out_ch2%1000/100	),
	.data21	(8'h30+adc_data_out_ch2%1000%100/10	),
	.data22	(8'h30+adc_data_out_ch2%10			),
	.data23	(" "),
	.data24	(" "),
	.data25	(" "),
	.data26	(" "),
	.data27	(" "),
	.data28	(" "),
	.data29	(" "),
	.data30	(" "),
	.data31	(" ")
	);
	
endmodule 