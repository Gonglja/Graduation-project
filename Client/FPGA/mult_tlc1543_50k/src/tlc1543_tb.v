`timescale 1ns / 1ps
module tlc1543_tb;
	reg					clk_50m         ;
    reg					rst_n			;
    //tlc1543_data_set intf             
    reg		[3:0]       tlc_channel_sw  ;
    wire  	[9:0]		adc_data_out    ;
    //tlc1543_spi intf                  
    reg					tlc1543_data    ;
    reg					tlc1543_eoc     ;
    wire              	tlc1543_clk     ;
    wire              	tlc1543_cs_n    ;
    wire              	tlc1543_addr    ;
	
	initial begin
		clk_50m         = 1'd0;
		rst_n	        = 1'd0;
		tlc_channel_sw  = 4'd0;
		tlc1543_data    = 1'd0;
		tlc1543_eoc     = 1'd0;
	
		#1000 rst_n = 1;
	end
	
	always #10 clk_50m = ~clk_50m;
	
	tlc1543 tlc1543 
	(
      .clk_50m         				(clk_50m		)
      ,.rst_n             			(rst_n			)
      //tlc1543_data_set intf	
      ,.tlc_channel_sw				(4'h0			)	//input       [3:0]       tlc_channel_sw  ,
      ,.adc_data_out  				(adc_data_out 	)	//output reg  [9:0]       adc_data_out    ,
      //tlc1543_spi intf
      ,.tlc1543_data				(tlc1543_data	)	//input                   tlc1543_data    ,
      ,.tlc1543_eoc 				(tlc1543_eoc 	)	//input                   tlc1543_eoc     ,
      ,.tlc1543_clk 				(tlc1543_clk 	)	//output reg              tlc1543_clk     ,
      ,.tlc1543_cs_n				(tlc1543_cs_n	)	//output reg              tlc1543_cs_n    ,
      ,.tlc1543_addr				(tlc1543_addr	)	//output reg              tlc1543_addr    
   );
	
	
endmodule