/********************************************************
发送数据：湿度整数+湿度小数 + 温度整数 + 温度小数 + 校验
          共5*8bit，先发送高位
温度量程：0--50度，只用取高8位，因为精度仅+/-2度
湿度量程：20%--90%			 
			 
*********************************************************/

module DHT11_opera(
                    input clk,
                    input sample_en,
                    inout data,
                    output reg data_rdy,
                    output [7:0] temperature,
                    output [7:0] humidity
                   ); 
 
reg sample_en_tmp1,sample_en_tmp2;                             
always @(posedge clk)                                      
begin                                                                         
   sample_en_tmp1 <=  sample_en;                               
   sample_en_tmp2 <=  sample_en_tmp1;                          
end                                                        
                                                           
wire sample_pulse = (~sample_en_tmp2) & sample_en_tmp1;    


reg data_tmp1,data_tmp2;                                    
always @(posedge clk)                                     
begin                                                     
   data_tmp1 <=  data;                                      
   data_tmp2 <=  data_tmp1;                                 
end                                                       
                                                          
wire data_pulse = (~data_tmp2) & data_tmp1;//rising edge     



////////////////////////////////////////////////////////////
reg [3:0] state = 0;
reg [26:0] power_up_cnt = 0;  //2^26 > 50e6，故大于1s

reg [20:0] wait_18ms_cnt = 0;//2^20*20e-9 = 21ms > 18ms
reg [11:0] wait_40us_cnt = 0;

reg [39:0] get_data;
reg [5:0] num = 0;//大于5*8
reg data_reg = 1;
reg link = 0;
always @(posedge clk)               
begin                               
   case(state)                      
     0  :      begin
                  link <= 0;
                  data_reg <= 1;//总线空闲时为高电平
                  power_up_cnt <= power_up_cnt + 1;
                  if(power_up_cnt[26])      //等待1s左右时间
                    begin
                       power_up_cnt <= 0;
                       state <= 1;
                    end
               end                   
     1  :      begin               
                  data_rdy <= 0;
                  if(sample_pulse) //启动转换命令    
                    begin
                       wait_18ms_cnt <= 0;
                       link <= 1;
                       data_reg <= 0; //主机拉低总线18ms以上
                       state <= 2; 
                    end
               end
     2  :      begin                                                             
                  wait_18ms_cnt <= wait_18ms_cnt + 1;
                  if(wait_18ms_cnt[20])
                    begin
                       wait_18ms_cnt <= 0;
                       wait_40us_cnt <= 0;
                       link <= 0;      //高阻，然后等待应答信号
                       data_reg <= 1;
                       state <= 3; 
                    end 
               end      
     3  :      begin                                           
                  wait_40us_cnt <= wait_40us_cnt + 1;  
                  if(wait_40us_cnt[11]) //延时等待40us  
                    begin                 
                       wait_40us_cnt <= 0; 
                       state <= 4; 
                    end
               end  
     4  :      begin                                                           
                  if(data_pulse) //响应结束       
                    begin                                    
                       get_data <= 40'd0;
                       num <= 0;
                       state <= 5;                           
                    end                                      
               end                                           
     5  :      begin                                    
                  if(data_pulse)   //第一位数据中的上升沿，延时40us，如果为低则为0，否则为1                   
                    begin          //因为0对应的高电平时间26us，1对应的高电平时间70us                     
                       wait_40us_cnt <= 0;
                       state <= 6;                      
                    end                                 
               end
     6  :      begin                                                                          
                  wait_40us_cnt <= wait_40us_cnt + 1;     
                  if(wait_40us_cnt[11]) //延时等待40us    
                    begin
                       wait_40us_cnt <= 0;
                       num <= num + 1;
                       if(data)
                          get_data <= {get_data[38:0],1'b1};                          
                       else
							     get_data <= {get_data[38:0],1'b0}; 
							  if(num == 39)
								  begin
									  num <= 0;
									  data_rdy <= 1;
									  state <= 1;  
								  end
							  else
								 state <= 5;  								 
                    end      
               end
     default:  state <= 0; 
   endcase       
end 


assign data  = link ? data_reg : 1'bz;
assign humidity    = get_data[39:32];
assign temperature = get_data[23:16];

                  

endmodule                                               