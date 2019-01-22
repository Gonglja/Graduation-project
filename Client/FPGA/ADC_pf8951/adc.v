//状态机版，不记得是否调试好
module adc (clk, rst_n, ren, scl,sda,data_out);
	input clk,rst_n,ren;
	inout sda;
	output scl;
	output [7:0]data_out;
	reg [7:0]data_out;
	reg scl, sda;
	
	//-------------------------------------
	reg [2:0]start_check;
	wire start_en;
	always@(posedge clk or negedge rst_n)
		if(!rst_n)  start_check<=3'd0;
		else
			begin 
				start_check[0]<=en;
				start_check[1]<=start_check[0];
				start_check[2]<=start_check[1];
			end
			//en上升沿启动,消抖???????
	assign start_en=~start_check[2]&start_check[1]&start_check[0];
	
	//-----------------------------------------		
	reg [2:0]cnt;
	reg [8:0]cnt_delay;
	reg scl_r;
	always@(posedge clk or negedge rst_n)
		if(!rst_n) cnt_delay<=9'd0;
		else if(cnt_delay==9'd499) cnt_delay<=9'd0;
		else cnt_delay <=cnt_delay +1'b1;
	
	//-------------------------------------------	
	always@(posedge clk or negedge rst_n)
		if(!rst_n) cnt<=3'd5;
		else begin
			case(cnt_delay)
			9'd124: cnt<=3'd1; 	// 高电平中间
			9'd249: cnt<=3'd2;  	//下降沿
			9'd374: cnt<=3'd3;   //低电平中间
			9'd499: cnt<=3'd0;  	//上升沿
			default: cnt<=3'd5;
			endcase
		end
		
	//------------------------------------------
	always@(posedge clk or negedge rst_n)
		if(!rst_n) scl_r<=1'b0;
		else if(cnt==3'd0) scl_r<=1'b1;
		else if(cnt==3'd2) scl_r<=1'b0;
	assign scl=scl_r;  						//iic 所用时钟
		 
	//--------------------------------------------------
	  //读、写时序 
	parameter  IDLE  = 4'd0; 
	parameter  START1  = 4'd1; 
	parameter  ADD1  = 4'd2; 
	parameter  ACK1  = 4'd3; 
	parameter  ADD2  = 4'd4; 
	parameter  ACK2  = 4'd5; 
	parameter  START2  = 4'd6; 
	parameter  ADD3  = 4'd7; 
	parameter  ACK3 = 4'd8; 
	parameter  DATA  = 4'd9; 
	parameter  ACK4 = 4'd10; 
	parameter  STOP  = 4'd11; 
	//----------------------------------
	reg sda_r;   //输出数据寄存器 
	reg sda_link; //输出数据sda信号inout方向控制位   
	reg[3:0] num; // 
	reg[7:0] db_r;  //在IIC上传送的数据寄存器 
	reg [3:0]state;
	reg [7:0]data;		
	reg [7:0]pre_st;
	
	assign sda = sda_link?sda_r:1'bz; 
	assign data_out = data; 
		
	always@(posedge clk_in or negedge rst_n)	//1us
		if(!rst_n) begin
			sda_r <= 1'b1; 
			sda_link <= 1'b0; 
			num <= 4'd0; 
			data <= 8'h00; 
			state<=IDLE;
			end
		else begin
		//	pre_st<=state;
			case(state)
			IDLE: begin
			      sda_link <= 1'b1;   //数据线sda为output 
					sda_r <= 1'b1; 
					if(start_en) begin
						db_r <=8'h90;   //h90!!!!!!!!!!!
						state<=START1;
						end
					else state<=IDLE;
					end
			START1: begin   //start
				if(cnt==3'd1) begin   //scl为高电平中间 
					sda_link <= 1'b1; //数据线sda为output 
					sda_r <= 1'b0;  //拉低数据线sda，产生起始位信号 
					state <= ADD1; 
					num <= 4'd0;  //num计数清零 
					end
				else
					state <= START1; 
				end
				
			ADD1: begin  //add1 //90
				if(cnt==3'd3)begin
					if(num == 4'd8) begin  
						num <= 4'd0;   //num计数清零 
						sda_r <= 1'b1; 
						sda_link <= 1'b0;  //sda置为高阻态(input) 
						state <= ACK1;
					//	case(pre_st)
					//	8'h02:state <= 8'h04; // h02 add1->ack h04
					//	8'h08:state <= 8'h10; // h08 ->h10
					//	default:;
					//	endcase
					  end 
					 else begin 
						state <= ADD1; 
						num <= num+1'b1; 
						case (num) 
						 4'd0: sda_r <= db_r[7]; 
						 4'd1: sda_r <= db_r[6]; 
						 4'd2: sda_r <= db_r[5]; 
						 4'd3: sda_r <= db_r[4]; 
						 4'd4: sda_r <= db_r[3]; 
						 4'd5: sda_r <= db_r[2]; 
						 4'd6: sda_r <= db_r[1]; 
						 4'd7: sda_r <= db_r[0]; 
						 default: ; 
						 endcase 
						end			
					end
				else
					state <= ADD1;
				end
			
			ACK1: begin  //ack 04
				   if(/*!sda*/cnt==3'd2) begin  
						state <= ADD2; //从机响应信号 
						db_r <= 8'h02; // h02  !!!!!!!!!!!!!!!
						end 
					else state <=ACK1;  //等待从机响应 
					end 
			ADD2: begin  //add2  //h02
				if(cnt==3'd3) begin 
					 if(num==4'd8) begin  
						num <= 4'd0;   //num计数清零 
						sda_r <= 1'b1; 
						sda_link <= 1'b0;  //sda置为高阻态(input)          
						state <= ACK2; 
					  end 
					 else begin 
						sda_link <= 1'b1;  //sda作为output 
						num <= num+1'b1; 
						case (num) 
						 4'd0: sda_r <= db_r[7]; 
						 4'd1: sda_r <= db_r[6]; 
						 4'd2: sda_r <= db_r[5]; 
						 4'd3: sda_r <= db_r[4]; 
						 4'd4: sda_r <= db_r[3]; 
						 4'd5: sda_r <= db_r[2]; 
						 4'd6: sda_r <= db_r[1]; 
						 4'd7: sda_r <= db_r[0]; 
						 default: ; 
						 endcase   
						state <= ADD2;   
					end
				else state <= ADD2; 
				end
			ACK2: begin  
				   if(/*!sda*/cnt==3'd2) begin  
						state <= START2; //从机响应信号 
						db_r <= 8'h91; // h91  !!!!!!!!!!!!!!!
						end 
					else state <=ACK2;  //等待从机响应 
					end 
			START2: begin
				if(cnt==3'd3) begin 
					sda_link <= 1'b1; //sda作为output 
					sda_r <= 1'b1;  //拉高数据线sda 
					state <= START2;
					end 
			   else if(cnt==3'd1) begin/ /scl为高电平中间 
					sda_r <= 1'b0;  //拉低数据线sda，产生起始位信号 
					state <= ADD3; 
					end   
			   else state <= START2; 
			 end 
			ADD3: begin
				 if(cnt==3'd3) begin 
					 if(num==4'd8) begin  
						num <= 4'd0;       //num计数清零 
						sda_r <= 1'b1; 
						sda_link <= 1'b0;  //sda置为高阻态(input) 
						state <= ACK3; 
					  end 
					 else begin 
						num <= num+1'b1; 
						case (num) 
						 4'd0: sda_r <= db_r[7]; 
						 4'd1: sda_r <= db_r[6]; 
						 4'd2: sda_r <= db_r[5]; 
						 4'd3: sda_r <= db_r[4]; 
						 4'd4: sda_r <= db_r[3]; 
						 4'd5: sda_r <= db_r[2]; 
						 4'd6: sda_r <= db_r[1]; 
						 4'd7: sda_r <= db_r[0]; 
						 default: ; 
						 endcase           
						state <= ADD3;      
					  end 
					end 
				  else cstate <= ADD3;     
				 end 
			ACK3: begin
				if(cnt==3'd3) begin  /*!sda*/
				 state <= DATA; //从机响应信号 
				 sda_link <= 1'b0; 
				end 
				else cstate <= ACK3;   //等待从机响应 
				end  
			DATA: begin
				if(num<=4'd7) begin 
				  state <= DATA; 
				  if(cnt==3'd1) begin  
					num <= num+1'b1;  
					case (num) 
					 4'd0: data[7] <= sda; 
					 4'd1: data[6] <= sda;   
					 4'd2: data[5] <= sda;  
					 4'd3: data[4] <= sda;  
					 4'd4: data[3] <= sda;  
					 4'd5: data[2] <= sda;  
					 4'd6: data[1] <= sda;  
					 4'd7: data[0] <= sda;  
					 default: ; 
					 endcase        
					end 
					end 
				else if((cnt==3'd3) && (num==4'd8)) begin 
					num <= 4'd0;   //num计数清零 
					state <= ACK4; 
				  end 
				else state <= DATA; 
				end 
			ACK4: begin
				if(cnt==3'd3) begin 
					 sda_link <= 1'b1; 
					 sda_r <= 1'b0;    //主机确认
					 state<=DATA;
					 end
				else 
					state <= ACK4; 
			STOP: begin
				if(cnt==3'd1) begin 
					sda_r <= 1'b1; //scl为高时，sda产生上升沿（结束信号） 
					state <= IDLE; 
				end 
				else state <= STOP; 
				end
			default: state <= IDLE; 
			endcase	
		end
		
endmodule
/*
uchar	readADC(void)
{
	start();
	iic_write(addwr); // 90
	ack();
	iic_write(02); // ctl_add  mo ren reg=0
	ack();
	
	start()
	iic_write(addrd); // 91
	ack();
	data=iic_read()
	stop();
	case(delay)
				
}	*/