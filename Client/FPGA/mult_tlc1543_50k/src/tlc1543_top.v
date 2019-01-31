`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/28 09:28:03
// Design Name: 
// Module Name: tlc1543_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tlc1543_top(
        input                   clk_50m         	,
        input                   rst_n           	,

		output	reg  [9:0]  	adc_data_out_ch1	,
		output	reg  [9:0]  	adc_data_out_ch2	,

        input                   tlc1543_data    	,
        input                   tlc1543_eoc     	,
        output                  tlc1543_clk     	,
        output                  tlc1543_cs_n    	,
        output                  tlc1543_addr    	
    );
    
    wire        tlc1543_eoc_ok      ;
    reg         tlc1543_ch_sw       ;
    reg  [3:0]  tlc_channel_sw      ;

    wire [9:0]  adc_data_out        ;
    
    
    reg         tlc1543_eoc_reg     ;
    //反馈监控
    always @(posedge clk_50m or negedge rst_n) begin
        if(!rst_n) begin
            tlc1543_eoc_reg <= 1'd0;
            tlc1543_ch_sw  <= 1'd0;
        end
        else begin
            tlc1543_eoc_reg <= tlc1543_eoc ;
            if(tlc1543_eoc == 1'd1 && tlc1543_eoc_reg == 1'd0 ) begin  //上升沿
                tlc1543_ch_sw <= ~tlc1543_ch_sw;
            end
            else if(tlc1543_eoc == 1'd0 && tlc1543_eoc_reg == 1'd1 ) begin //下降沿
                tlc1543_ch_sw <= tlc1543_ch_sw;
            end
            else begin
                tlc1543_ch_sw <= tlc1543_ch_sw;
            end
        end
    end
    
    always @(posedge clk_50m or negedge rst_n)begin
        if(!rst_n) begin
            tlc_channel_sw      <=  4'd0;
        end
        else begin
            if(tlc1543_ch_sw) begin
                tlc_channel_sw  <=  4'h2;
            end
            else begin
                tlc_channel_sw  <=  4'ha;
            end
        end
    end
	
	always @(posedge clk_50m or negedge rst_n)begin
        if(!rst_n) begin
            adc_data_out_ch1    <= 10'd0;
            adc_data_out_ch2    <= 10'd0;
        end
        else begin
			if(tlc1543_ch_sw) begin
                if(tlc1543_eoc == 1'd1 && tlc1543_eoc_reg == 1'd0 ) begin  //上升沿
					adc_data_out_ch1 <= adc_data_out_ch1;
				end
				else if(tlc1543_eoc == 1'd0 && tlc1543_eoc_reg == 1'd1 ) begin //下降沿
					adc_data_out_ch1 <= adc_data_out;
				end
				else begin
					adc_data_out_ch1 <= adc_data_out_ch1;
				end
            end
            else begin
                if(tlc1543_eoc == 1'd1 && tlc1543_eoc_reg == 1'd0 ) begin  //上升沿
					adc_data_out_ch2 <= adc_data_out_ch2;
				end
				else if(tlc1543_eoc == 1'd0 && tlc1543_eoc_reg == 1'd1 ) begin //下降沿
					adc_data_out_ch2 <= adc_data_out;
				end
				else begin
					adc_data_out_ch2 <= adc_data_out_ch2;
				end
            end
            
        end
    end
    
    
    
    tlc1543 tlc1543
    (
        .clk_50m            (clk_50m            ),  // input                   clk_50m         ,
        .rst_n              (rst_n              ),  // input                   rst             ,
        // //tlc1543_data_set intf                       
        .tlc_channel_sw     (tlc_channel_sw     ),  // input       [3:0]       tlc_channel_sw  ,
        .adc_data_out       (adc_data_out       ),  // output reg  [9:0]       adc_data_out    ,
        // //tlc1543_spi intf                            
        .tlc1543_data       (tlc1543_data       ),  // input                   tlc1543_data    ,
        .tlc1543_eoc        (tlc1543_eoc        ),  // input                   tlc1543_eoc     ,
        .tlc1543_clk        (tlc1543_clk        ),  // output reg              tlc1543_clk     ,
        .tlc1543_cs_n       (tlc1543_cs_n       ),  // output reg              tlc1543_cs_n    ,
        .tlc1543_addr       (tlc1543_addr       ),  // output reg              tlc1543_addr    , 
        .tlc1543_eoc_ok     (tlc1543_eoc_ok     )   // output reg              tlc1543_data_ok 
    );
endmodule
