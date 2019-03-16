/*****************************************************************************************
************************************电力电子实验室******************************************
***************************************宫兰景**********************************************
**********************************lcd1602显示模块接口***************************************
**********************************时间：2017年7月7日****************************************
******************************************************************************************/


module lcd1602(
              input clk,      //50M
				  input rst_n,
				  output reg lcd_rs,    //0:write order; 1:write data   
				  output lcd_rw,        //0:write data;  1:read data
				  output reg lcd_en,    //negedge
				  output reg [7:0] lcd_data,
///////////////////////////////////第一行//////////////////////////////////////
				  input [7:0]data0,input [7:0]data1,input [7:0]data2,
				  input [7:0]data3,input [7:0]data4,input [7:0]data5,
				  input [7:0]data6,input [7:0]data7,input [7:0]data8,
				  input [7:0]data9,input [7:0]data10,input [7:0]data11,
				  input [7:0]data12,input [7:0]data13,input [7:0]data14,input [7:0]data15,
///////////////////////////////////第二行/////////////////////////////////////////
				  input [7:0]data16,input [7:0]data17,input [7:0]data18,
				  input [7:0]data19,input [7:0]data20,input [7:0]data21,
				  input [7:0]data22,input [7:0]data23,input [7:0]data24,
				  input [7:0]data25,input [7:0]data26,input [7:0]data27,
				  input [7:0]data28,input [7:0]data29,input [7:0]data30,input [7:0]data31
				  );

//--------------------lcd1602 order----------------------------
parameter    Mode_Set    =  8'h38,  //
				 Cursor_Set  =  8'h0c,  //开显示
				 Address_Set =  8'h06,  //
				 Clear_Set   =  8'h01;

/****************************LCD1602 Display Data****************************/       
wire [7:0] addr1,addr2;   //write address
//
//wire [3:0] dat0,dat1;
//---------------------------------1s counter-----------------------------------
//reg [31:0] cnt1;
//reg [3:0] data_r0,data_r1;
//always@(posedge clk or negedge rst_n)
//begin
//        if(!rst_n)
//                begin
//                        cnt1 <= 1'b0;
//                        data_r0 <= 1'b0;
//                        data_r1 <= 1'b0;
//                end
//        else if(cnt1==32'd50000000)
//                begin
//                        if(data_r0==8'd9)
//                                begin
//                                        data_r0 <= 1'b0;
//                                        if(data_r1==8'd9)
//                                                data_r1 <= 1'b0;
//                                        else
//                                                data_r1 <= data_r1 + 1'b1;
//                                end
//                        else
//                                data_r0 <= data_r0 + 1'b1;
//                        cnt1 <= 1'b0;
//                end
//        else
//                cnt1 <= cnt1 + 1'b1;
//end
//
//assign dat0 =  data_r0 ;     
//assign dat1 =  data_r1 ;

//-------------------address------------------
assign addr1 = 8'h80;
assign addr2 = 8'h80+8'h40;

/****************************LCD1602 Driver****************************/                         
//-----------------------lcd1602 clk_en---------------------
reg [31:0] cnt;
reg lcd_clk_en;
always @(posedge clk or negedge rst_n)      
begin
        if(!rst_n)
                begin
                        cnt <= 1'b0;
                        lcd_clk_en <= 1'b0;
                end
        else if(cnt == 32'h2499)   //500us
                begin
                        lcd_clk_en <= 1'b1;
                        cnt <= 1'b0;
                end
        else
                begin
                        cnt <= cnt + 1'b1;
                        lcd_clk_en <= 1'b0;
                end
end

//-----------------------lcd1602 display state-------------------------------------------
reg [11:0] state1;
always@(posedge clk or negedge rst_n)
begin
        if(!rst_n)
                begin
                        state1 <= 1'b0;
                        lcd_rs <= 1'b0;
                        lcd_en <= 1'b0;
                        lcd_data <= 1'b0;   
                end
        else if(lcd_clk_en)     
                begin
                        case(state1)
                                //-------------------init_state---------------------初始化
                                 12'd0: begin               
                                                lcd_rs <= 1'b0;
                                                lcd_en <= 1'b1;
                                                lcd_data <= Mode_Set;   
                                                state1 <= state1 + 1'd1;
                                                end
                                 12'd1: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                                end
                                 12'd2: begin
                                                lcd_rs <= 1'b0;
                                                lcd_en <= 1'b1;
                                                lcd_data <= Cursor_Set;
                                                state1 <= state1 + 1'd1;
                                                end
                                 12'd3: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                                end
                                 12'd4: begin
                                                lcd_rs <= 1'b0;
                                                lcd_en <= 1'b1;
                                                lcd_data <= Address_Set;
                                                state1 <= state1 + 1'd1;
                                                end
                                 12'd5: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                                end
                                 12'd6: begin
                                                lcd_rs <= 1'b0;
                                                lcd_en <= 1'b1;
                                                lcd_data <= Clear_Set;
                                                state1 <= state1 + 1'd1;
                                                end
                                 12'd7: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                                end
                                               
////////////////////////////////////////--------------------work state--------------------  //写数据///////////////////////////
/////////////////////////////////////////////////////第一行////////////////////////////////////////////////////////////////////
                                 12'd8: begin              
                                                lcd_rs <= 1'b0;
                                                lcd_en <= 1'b1;
                                                lcd_data <= addr1;   //write addr
                                                state1 <= state1 + 1'd1;
                                                end
                                 12'd9: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                                end
                                 12'd10: begin
                                                lcd_rs <= 1'b1;
                                                lcd_en <= 1'b1;
                                                lcd_data <= data0;   //write data
                                                state1 <= state1 + 1'd1;
                                                 end
                                 12'd11: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                                end
                                 12'd12: begin
                                                lcd_rs <= 1'b1;
                                                lcd_en <= 1'b1;
                                                lcd_data <= data1;   //write data
                                                state1 <= state1 + 1'd1;
                                                 end
                                 12'd13: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                                end
                                 12'd14: begin
                                                lcd_rs <= 1'b1;
                                                lcd_en <= 1'b1;
                                                lcd_data <= data2;   //write data
                                                state1 <= state1 + 1'd1;
                                                 end
                                 12'd15: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                                end
                                 12'd16: begin
                                                lcd_rs <= 1'b1;
                                                lcd_en <= 1'b1;
                                                lcd_data <= data3;   //write data
                                                state1 <= state1 + 1'd1;
                                                 end
                                 12'd17: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                                end   
                                 12'd18: begin
                                                lcd_rs <= 1'b1;
                                                lcd_en <= 1'b1;
                                                lcd_data <= data4;   //write data: tens digit
                                                state1 <= state1 + 1'd1;
                                                 end
                                 12'd19: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                                 end
                                 12'd20: begin
                                                lcd_rs <= 1'b1;
                                                lcd_en <= 1'b1;
                                                lcd_data <= data5;   //write data: single digit
                                                state1 <= state1 + 1'd1;
                                                end
										   12'd21: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                                 end
										   12'd22: begin
                                                lcd_rs <= 1'b1;
                                                lcd_en <= 1'b1;
                                                lcd_data <= data6;   //write data: single digit
                                                state1 <= state1 + 1'd1;
                                                end
										   12'd23: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                                 end
										   12'd24: begin
                                                lcd_rs <= 1'b1;
                                                lcd_en <= 1'b1;
                                                lcd_data <= data7;   //write data: single digit
                                                state1 <= state1 + 1'd1;
                                                end
                                 12'd25: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                           end
			                        12'd26: begin
                                                lcd_rs <= 1'b1;
                                                lcd_en <= 1'b1;
                                                lcd_data <= data8;   //write data: single digit
                                                state1 <= state1 + 1'd1;
                                                end
                                 12'd27: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                           end
										   12'd28: begin
                                                lcd_rs <= 1'b1;
                                                lcd_en <= 1'b1;
                                                lcd_data <= data9;   //write data: single digit
                                                state1 <= state1 + 1'd1;
                                                end
                                 12'd29: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                           end
											12'd30: begin
                                                lcd_rs <= 1'b1;
                                                lcd_en <= 1'b1;
                                                lcd_data <= data10;   //write data: single digit
                                                state1 <= state1 + 1'd1;
                                                end
                                 12'd31: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                           end
										   12'd32: begin
                                                lcd_rs <= 1'b1;
                                                lcd_en <= 1'b1;
                                                lcd_data <= data11;   //write data: single digit
                                                state1 <= state1 + 1'd1;
                                                end
                                 12'd33: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                           end
											12'd34: begin
                                                lcd_rs <= 1'b1;
                                                lcd_en <= 1'b1;
                                                lcd_data <= data12;   //write data: single digit
                                                state1 <= state1 + 1'd1;
                                                end
                                 12'd35: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                           end
											12'd36: begin
                                                lcd_rs <= 1'b1;
                                                lcd_en <= 1'b1;
                                                lcd_data <= data13;   //write data: single digit
                                                state1 <= state1 + 1'd1;
                                                end
                                 12'd37: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                           end
											12'd38: begin
                                                lcd_rs <= 1'b1;
                                                lcd_en <= 1'b1;
                                                lcd_data <= data14;   //write data: single digit
                                                state1 <= state1 + 1'd1;
                                                end
                                 12'd39: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                           end
											12'd40: begin
                                                lcd_rs <= 1'b1;
                                                lcd_en <= 1'b1;
                                                lcd_data <= data15;   //write data: single digit
                                                state1 <= state1 + 1'd1;
                                                end
                                 12'd41: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                           end
////////////////////////////////////////////////第二行/////////////////////////////////////////////////////////
										   12'd42: begin              
                                                lcd_rs <= 1'b0;
                                                lcd_en <= 1'b1;
                                                lcd_data <= addr2;   //write addr
                                                state1 <= state1 + 1'd1;
                                                end
                                 12'd43: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                                end
                                 12'd44: begin
                                                lcd_rs <= 1'b1;
                                                lcd_en <= 1'b1;
                                                lcd_data <= data16;   //write data
                                                state1 <= state1 + 1'd1;
                                                 end
                                 12'd45: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                                end
                                 12'd46: begin
                                                lcd_rs <= 1'b1;
                                                lcd_en <= 1'b1;
                                                lcd_data <= data17;   //write data
                                                state1 <= state1 + 1'd1;
                                                 end
                                 12'd47: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                                end
                                 12'd48: begin
                                                lcd_rs <= 1'b1;
                                                lcd_en <= 1'b1;
                                                lcd_data <= data18;   //write data
                                                state1 <= state1 + 1'd1;
                                                 end
                                 12'd49: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                                end
                                 12'd50: begin
                                                lcd_rs <= 1'b1;
                                                lcd_en <= 1'b1;
                                                lcd_data <= data19;   //write data
                                                state1 <= state1 + 1'd1;
                                                 end
                                 12'd51: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                                end   
                                 12'd52: begin
                                                lcd_rs <= 1'b1;
                                                lcd_en <= 1'b1;
                                                lcd_data <= data20;   //write data: tens digit
                                                state1 <= state1 + 1'd1;
                                                 end
                                 12'd53: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                                 end
										   12'd54: begin
                                                lcd_rs <= 1'b1;
                                                lcd_en <= 1'b1;
                                                lcd_data <= data21;   //write data: tens digit
                                                state1 <= state1 + 1'd1;
                                                 end
                                 12'd55: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                                 end
											12'd56: begin
                                                lcd_rs <= 1'b1;
                                                lcd_en <= 1'b1;
                                                lcd_data <= data22;   //write data: tens digit
                                                state1 <= state1 + 1'd1;
                                                 end
                                 12'd57: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                                 end
										   12'd58: begin
                                                lcd_rs <= 1'b1;
                                                lcd_en <= 1'b1;
                                                lcd_data <= data23;   //write data: tens digit
                                                state1 <= state1 + 1'd1;
                                                 end
                                 12'd59: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                                 end
										   12'd60: begin
                                                lcd_rs <= 1'b1;
                                                lcd_en <= 1'b1;
                                                lcd_data <= data24;   //write data: tens digit
                                                state1 <= state1 + 1'd1;
                                                 end
                                 12'd61: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                                 end
											12'd62: begin
                                                lcd_rs <= 1'b1;
                                                lcd_en <= 1'b1;
                                                lcd_data <= data25;   //write data: tens digit
                                                state1 <= state1 + 1'd1;
                                                 end
                                 12'd63: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                                 end
											12'd64: begin
                                                lcd_rs <= 1'b1;
                                                lcd_en <= 1'b1;
                                                lcd_data <= data26;   //write data: tens digit
                                                state1 <= state1 + 1'd1;
                                                 end
                                 12'd65: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                                 end
											12'd66: begin
                                                lcd_rs <= 1'b1;
                                                lcd_en <= 1'b1;
                                                lcd_data <= data27;   //write data: tens digit
                                                state1 <= state1 + 1'd1;
                                                 end
                                 12'd67: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                                 end
											12'd68: begin
                                                lcd_rs <= 1'b1;
                                                lcd_en <= 1'b1;
                                                lcd_data <= data28;   //write data: tens digit
                                                state1 <= state1 + 1'd1;
                                                 end
                                 12'd69: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                                 end
											12'd70: begin
                                                lcd_rs <= 1'b1;
                                                lcd_en <= 1'b1;
                                                lcd_data <= data29;   //write data: tens digit
                                                state1 <= state1 + 1'd1;
                                                 end
                                 12'd71: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                                 end
											12'd72: begin
                                                lcd_rs <= 1'b1;
                                                lcd_en <= 1'b1;
                                                lcd_data <= data30;   //write data: tens digit
                                                state1 <= state1 + 1'd1;
                                                 end
                                 12'd73: begin
                                                lcd_en <= 1'b0;
                                                state1 <= state1 + 1'd1;
                                                 end
                                 12'd74: begin
                                                lcd_rs <= 1'b1;
                                                lcd_en <= 1'b1;
                                                lcd_data <= data31;   //write data: single digit
                                                state1 <= state1 + 1'd1;
                                                end
                                 12'd75: begin
                                                lcd_en <= 1'b0;
                                                state1 <= 12'd8;
                                           end
                                default: state1 <= 12'bxxxxxxxx;
                        endcase
                end
end

assign lcd_rw = 1'b0;   //only write


endmodule 