module dht11(clk,nRST,Data,data1);
input clk,nRST;
inout Data;
output data1;

reg [31:0]counter;//计数器寄存器
reg [4:0]state;//状态机状态寄存器
reg [5:0] rec=0;//读取数据位数寄存器
reg read_begin;//读取数据开始标志位
reg [39:0]data,data1;
reg read_done; //读取数据完成标志位
reg flag;
reg data_reg;

parameter state0=0;
parameter state1=1;
parameter state2=2;
parameter state3=3;
parameter state4=4;
parameter state5=5;
parameter state6=6;
parameter state7=7;
parameter state8=8;
parameter state9=9;
parameter state10=10;
parameter state11=11;
parameter state12=12;

//确定Data端口到底是作为输入还是输出  1输出 0输入
assign Data=(flag)?data_reg:1'bz;


//分频部分
reg clkout;
parameter divd=25;
reg[7:0] clk_cnt;
initial begin
	 cnt<=8'b0;
	 clkout<=1'b0;
	 end
	 
always@(posedge clk)
	begin
	if(clk_cnt<divd)
		clk_cnt<=clk_cnt+8'b1;
	else
	  begin
		clk_cnt<=8'b0;
		clkout<=~clkout;
	  end
	end
	
//----------------------DHT11--------------------------
//软复位
reg [15:0]cnt;
reg clk_nRST;
always @(posedge clkout or negedge nRST )begin
	if(!nRST)begin
		cnt <= 16'd0;
	   clk_nRST <= 0;	
	end
	else begin
		if(cnt ==16'd60000 -1 )begin
		   cnt <= 16'd0;
			clk_nRST <=0;
		end 
		else begin
			cnt <= cnt + 1'b1;
			clk_nRST <= 1;
		end
	end
end
//时序开始
always @(posedge clkout or negedge clk_nRST )
begin
	if(!clk_nRST)
		begin
			  state<=0 ;
			  data<=0;
		end
	else
		begin   
			case (state)
			  state0://总线空闲状态位高电平
						begin
						if(counter==500000)//0.5s=1000ns*500_000
							   begin
									  counter<=0;
									  state<=state1;
								  
							   end
						else begin
									  
									  flag<=1;
									  data_reg<=1;
									  read_done<=0;   						  
									  counter<=counter+1;// 
								end
						end
			  state1://主机把总线拉低必须大于18ms
						begin
							if(counter==19000)   //19ms
								begin
									  flag<=0;
									  state<=state2;
									  counter<=0;
								end
							else
								begin
									  data_reg<=0;
									  counter<=counter+1'b1;
								end 
						end 
			  state2://总线由上拉电阻拉个高，主机延时20us
						begin
						  counter<=counter+1'b1;
							if(counter==20)      //20us~30us
							  begin
								  state<=state3;
								  counter<=0;             
							  end
						 end
						// 判断从机是否有低电平响应
			  state3://DHT信号如果为高，一直等，直到数据位为低
						 begin
							if(Data==1)
								begin
									state<=state3; 
								end
							else
							  begin
									state<=state4;  
							  end
							end
			  state4://DHT信号如果为低，一直等，直到数据位为高
						 begin
							 if(Data==0)
								 begin
									state<=state4;
								 end
							 else
								  begin
									state<=state5;
								  end
						 end
			  state5://DHT信号如果为高，一直等，直到数据位为低
						begin
							if(Data==1)
							  begin
								 state<=state5; 
							  end
							else
							  begin
								 state<=state6;
							  end
						 end
			  state6://DHT信号如果为低，一直等，直到数据位为高，读取数据标志位为1
						  begin
								if(Data==0)
									begin
									  state<=state6;
									end
							  else
									begin
									  read_begin<=1;
									  state<=state7;
									end
							end
				state7:
						  begin
							  if(Data==1)
								 begin
								 state<=state8;               
								 end
						  end
				state8:
					 begin
						if(counter==50)     //50us
							begin
								counter<=0;
								state<=state9; 
							end           
						 else 
							 begin     
								counter<=counter+1;
								state<=state8;
						  end
					 end
				  //进入数据采集状态 
				 state9:
					  begin
						  if(Data==1)                
							  begin
									data[0]<=1;
							  end
										
							else 
							  begin
									data[0]<=0;   
							  end
							state<=state12;
							rec <= rec+1;
						end
			  //////////////////////////////////////////////       			
				state12:
					  begin 
						  if(rec >= 40)
							  begin
								  state<=state0;
								  rec <= 0;
								  data1<=data;
								  flag<=1;
							  end
						  else
							  begin
								  data<= data<<1;
								  if(Data==1)
										state<=state10;
								  else
										state<=state11;
							  end
					  end									
			  state10:
						begin
							 if(Data==1)
								 begin
									state<=state10;              
								 end
							 else
								 begin
									state<=state11;
								 end
						end
										
			  state11:
						begin
							if(Data==0)
							  begin
								 state<=state11;                
							  end
							else
							  begin
								 state<=state8;
							  end
						end   
			  default: begin state<=state0;end            
			  endcase           
		end
end
endmodule 