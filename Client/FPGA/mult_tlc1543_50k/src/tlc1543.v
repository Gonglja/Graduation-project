`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/14 16:02:35
// Design Name: 
// Module Name: tlc1543
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


module tlc1543(
        input                   clk_50m         ,
        input                   rst_n           ,
        //tlc1543_data_set intf
        input       [3:0]       tlc_channel_sw  ,
        output reg  [9:0]       adc_data_out    ,
        //tlc1543_spi intf
        input                   tlc1543_data    ,
        input                   tlc1543_eoc     ,
        output reg              tlc1543_clk     ,
        output                  tlc1543_cs_n    ,
        output reg              tlc1543_addr    ,
        output reg              tlc1543_eoc_ok       
    );
    
    reg             [15:0]      tlc_time_cnt    ;
    reg             [15:0]      tlc_time_ctrl   ;
    reg                         tlc1543_eoc_reg ;
    // reg                         tlc1543_eoc_ok  ;
    // cs控制
    assign tlc1543_cs_n = 1'd0 ;
    //反馈监控
    always @(posedge clk_50m or negedge rst_n) begin
        if(!rst_n) begin
            tlc1543_eoc_reg <= 1'd0;
            tlc1543_eoc_ok  <= 1'd0;
        end
        else begin
            tlc1543_eoc_reg <= tlc1543_eoc ;
            if(tlc1543_eoc == 1'd1 && tlc1543_eoc_reg == 1'd0 ) begin
                tlc1543_eoc_ok <= 1'd1;
            end
            else if(tlc1543_eoc == 1'd0 && tlc1543_eoc_reg == 1'd1 ) begin
                tlc1543_eoc_ok <= 1'd0;
            end
            else begin
                tlc1543_eoc_ok <= tlc1543_eoc_ok;
            end
        end
    end
    // 时钟产生
    always @(posedge clk_50m or negedge rst_n) begin
        if(!rst_n) begin
            tlc_time_cnt <= 16'd0;
            tlc1543_clk  <= 1'd0;
        end
        else begin
            if(tlc1543_eoc_ok) begin
                if(tlc_time_cnt < 16'd499) begin
                    tlc_time_cnt <= tlc_time_cnt +1'd1;
                end
                else begin
                    tlc_time_cnt <= 16'd0;
                    tlc1543_clk <= ~tlc1543_clk;
                end
            end 
            else begin
                tlc_time_cnt <= 16'd0 ;
            end
        end
    end
    // 时序匹配
    always @(posedge clk_50m or negedge rst_n) begin
        if(!rst_n) begin
            tlc_time_ctrl <= 16'd0;
        end
        else begin
            if(tlc_time_cnt == 16'd499) begin
                if(tlc_time_ctrl < 16'd19) begin
                    tlc_time_ctrl <= tlc_time_ctrl + 1'd1;
                end
                else begin
                    tlc_time_ctrl <= 16'd0;
                end
            end
            else begin
                tlc_time_ctrl <= tlc_time_ctrl ;
            end
        end
    end
    
    // 地址写入
    always @(posedge clk_50m or negedge rst_n) begin
        if(!rst_n) begin
            tlc1543_addr <= 1'd0;
        end
        else begin
            case(tlc_time_ctrl)
                16'd0 : begin 
                       if(tlc_time_cnt==16'd1) begin
                           tlc1543_addr <= tlc_channel_sw[3];
                       end
                       else begin
                           tlc1543_addr <= tlc1543_addr;
                       end
                end
                16'd1: begin 
                       if(tlc_time_cnt==16'd499) begin
                           tlc1543_addr <= tlc_channel_sw[2];
                       end
                       else begin
                           tlc1543_addr <= tlc1543_addr;
                       end
                end 
                16'd3: begin 
                        if(tlc_time_cnt==16'd499) begin
                            tlc1543_addr <= tlc_channel_sw[1];
                        end
                        else begin
                            tlc1543_addr <= tlc1543_addr;
                        end
                end 
                16'd5 : begin 
                        if(tlc_time_cnt==16'd499) begin
                            tlc1543_addr <= tlc_channel_sw[0];
                        end
                        else begin
                            tlc1543_addr <= tlc1543_addr;
                        end
                end
                16'd7 : begin 
                        if(tlc_time_cnt==16'd499) begin
                            tlc1543_addr <= 4'd0;
                        end
                        else begin
                            tlc1543_addr <= tlc1543_addr;
                        end
                end
                default tlc1543_addr <= tlc1543_addr;
            endcase
        end
    end
    
    always @(posedge clk_50m or negedge rst_n) begin
        if(!rst_n) begin
            adc_data_out <= 10'd0;
        end
        else begin
            case(tlc_time_ctrl)
                16'd1  : adc_data_out[9] <= tlc1543_data;
                16'd3  : adc_data_out[8] <= tlc1543_data;
                16'd5  : adc_data_out[7] <= tlc1543_data;
                16'd7  : adc_data_out[6] <= tlc1543_data;
                16'd9  : adc_data_out[5] <= tlc1543_data;
                16'd11 : adc_data_out[4] <= tlc1543_data;
                16'd13 : adc_data_out[3] <= tlc1543_data;
                16'd15 : adc_data_out[2] <= tlc1543_data;
                16'd17 : adc_data_out[1] <= tlc1543_data;
                16'd19 : adc_data_out[0] <= tlc1543_data;
                default adc_data_out <= adc_data_out;
            endcase
        end
    end
    
    // always @(posedge clk_50m or negedge rst_n) begin
        // if(!rst_n) begin
            // tlc1543_data_ok <= 1'dz;
        // end
        // else begin
            // if(tlc_time_ctrl == 16'd0) begin
                // case(tlc_time_cnt)
                    // 16'd1: tlc1543_data_ok      <= ~tlc1543_data_ok ;
                    // default tlc1543_data_ok <= tlc1543_data_ok  ;
                // endcase
            // end
            // else begin
                // tlc1543_data_ok <= tlc1543_data_ok;
            // end
        // end
    // end
    
endmodule
