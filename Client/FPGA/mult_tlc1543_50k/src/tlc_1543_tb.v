`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/15 14:55:09
// Design Name: 
// Module Name: tlc_1543_tb
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


module tlc_1543_tb(

    );
    reg                   clk_50m           ;
    reg                   clk_50k          ;
    reg                   rst               ;
    //tlc1543_data_set intf                 
    reg       [3:0]       tlc_channel_sw    ;
    wire      [9:0]       adc_data_out      ;
    //tlc1543_spi intf                      
    reg                   tlc1543_data      ;
    reg                   tlc1543_eoc       ;
    wire                  tlc1543_clk       ;
    wire                  tlc1543_cs_n      ;
    wire                  tlc1543_addr      ;
    
    reg       [15:0]      tlc1543_outcnt    ;
    
    reg       [9:0 ]      tlc1543_data_test ;
    
    initial begin
        clk_50m = 1'd0;
        clk_50k = 1'd0;
        rst     = 1'd0;
        tlc1543_data_test = 10'd0;
        tlc1543_eoc  =1'd0;
        tlc1543_data = 1'd0;
        
        #1000 rst = 1'd1;
    end
    
    always #10      clk_50m  = ~clk_50m  ;
    always #10000   clk_50k = ~clk_50k ;
    
    always @(posedge clk_50k)begin
        if(!rst) begin
            tlc1543_outcnt <= 16'd0;
        end
        else begin
            if(tlc1543_outcnt < 16'd15) begin
                tlc1543_outcnt <= tlc1543_outcnt + 1'd1;
                if(tlc1543_outcnt < 9) begin
                    tlc1543_eoc <= 1'd1;
                end
                else begin
                    tlc1543_eoc <= 1'd0;
                end
                
            end
            else begin
                tlc1543_outcnt <= 16'd0;
                tlc1543_eoc <= 1'd1;
            end
        end
    end
    
    always @(posedge clk_50k)begin
        if(!rst) begin
            tlc1543_data_test <= 10'd0;
        end
        else begin
            case (tlc1543_outcnt)
                0: tlc1543_data_test <= tlc1543_data_test + 10'd10;
                default : tlc1543_data_test <= tlc1543_data_test;
            endcase 
        end
    end
    
    always @(posedge clk_50m)begin
        if(!rst) begin
            tlc1543_data <= 1'd0;
        end
        else begin
            case (tlc1543_outcnt)
                0: tlc1543_data <= tlc1543_data_test[9];
                1: tlc1543_data <= tlc1543_data_test[8];
                2: tlc1543_data <= tlc1543_data_test[7];
                3: tlc1543_data <= tlc1543_data_test[6];
                4: tlc1543_data <= tlc1543_data_test[5];
                5: tlc1543_data <= tlc1543_data_test[4];
                6: tlc1543_data <= tlc1543_data_test[3];
                7: tlc1543_data <= tlc1543_data_test[2];
                8: tlc1543_data <= tlc1543_data_test[1];
                9: tlc1543_data <= tlc1543_data_test[0];
            endcase 
        end
    end
    
    tlc1543_top tlc1543_top
    (
        .clk_50m         (clk_50m       ),  // input                   clk_50m         ,
        .rst_n           (rst           ),  // input                   rst             ,                 

        // //tlc1543_spi intf                       
        .tlc1543_data    (tlc1543_data  ),  // input                   tlc1543_data    ,
        .tlc1543_eoc     (tlc1543_eoc   ),  // input                   tlc1543_eoc     ,
        .tlc1543_clk     (tlc1543_clk   ),  // output reg              tlc1543_clk     ,
        .tlc1543_cs_n    (tlc1543_cs_n  ),  // output reg              tlc1543_cs_n    ,
        .tlc1543_addr    (tlc1543_addr  )   // output reg              tlc1543_addr     
    );
    
endmodule
