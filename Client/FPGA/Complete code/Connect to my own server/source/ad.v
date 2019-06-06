module ad(clk, rst_n,controlword, ren, scl,sda,data_out);
	input clk,rst_n,ren;
	input [7:0]controlword;
	inout sda;
	output scl;
	output [7:0]data_out;
	reg [7:0]data_out;
	reg scl, sda;
	
	parameter  fre=8'd50;  //T=1us
	reg [7:0] cnt;
	reg clk_in;
	//reg [7:0]controlword=8'h00;
	//-------------------------------------
	reg [2:0]start_check;	//en=1启动,消抖
	wire start_en;
	always@(posedge clk or negedge rst_n)
		if(!rst_n)  start_check<=3'd0;
		else
			begin 
				start_check[0]<=ren;//ren
				start_check[1]<=start_check[0];
				start_check[2]<=start_check[1];
			end
	assign start_en=start_check[2]&start_check[1]&start_check[0];
	
	//-----------------------------------------
	
	always@(posedge clk )  // 分频 
		if(start_en)
			begin
				cnt<=cnt+1'b1;
				if(cnt==fre>>1) begin 
					clk_in=~clk_in; 
					end 
				else if(cnt==fre) 
					begin 
					clk_in=~clk_in;
					cnt<=8'd0; 
					end 				
			end
		 
	//--------------------------------------------------
	
	reg [1:0]ack;
	reg [7:0]data,delay;		
	reg temp;
	always@(posedge clk_in or negedge rst_n)	//1us
		if(!rst_n) begin
			delay<=8'd0;
			ack<=2'b00;
			end
		else
			begin
			delay <=delay + 1'b1;
			if(ack==2'b00)
				case(delay)
				8'd1 :sda<=1;
				8'd2 :scl<=1;  //scl<=1;
				8'd6 :sda<=0;
				8'd9 :scl<=0;
				
				8'd11:sda<=1;  //addwr h90  1001 0000 /1   
				8'd15:scl<=1;
				8'd19:scl<=0;
				8'd21:sda<=0;  //0		  
				8'd25:scl<=1;
				8'd29:scl<=0;
				8'd31:sda<=0;  //0 
				8'd35:scl<=1;
				8'd39:scl<=0;
				8'd41:sda<=1;  //1
				8'd45:scl<=1; 
				8'd49:scl<=0; 
				8'd51:sda<=0;  //0
				8'd55:scl<=1;
				8'd59:scl<=0;
				8'd61:sda<=0;  //0
				8'd65:scl<=1;
				8'd69:scl<=0;
				8'd71:sda<=0;  //0
				8'd75:scl<=1;
				8'd79:scl<=0;
				8'd81:sda<=0;  //0
				8'd85:scl<=1;
				8'd89:scl<=0;  //end
				8'd91:sda<=1'bz;
				8'd95:scl<=1;
				8'd98:temp<=sda;
				default: if((delay>100))//&&(delay<255)&&(temp==0) 
								begin ack<=2'b01; delay<=8'd0;scl<=0; end
				endcase
				
			else if(ack==2'b01)			
				case(delay)
				8'd2 :sda<=controlword[7];	//0  h02 control byte    40
				8'd6 :scl<=1;
				8'd10:scl<=0;	
				8'd12:sda<=controlword[6];  //1
				8'd16:scl<=1;
				8'd20:scl<=0;
				8'd22:sda<=controlword[5];  //0
				8'd26:scl<=1;
				8'd30:scl<=0;
				8'd32:sda<=controlword[4];  //0
				8'd36:scl<=1; 
				8'd40:scl<=0; 
				8'd42:sda<=controlword[3];  //0
				8'd46:scl<=1;
				8'd50:scl<=0;
				8'd52:sda<=controlword[2];  //0
				8'd56:scl<=1;
				8'd60:scl<=0;
				8'd62:sda<=controlword[1];  //0
				8'd66:scl<=1;
				8'd70:scl<=0;
				8'd72:sda<=controlword[0];  //0
				8'd76:scl<=1;
				8'd80:scl<=0;  //end
				8'd82:sda<=1'bz;
				8'd86:scl<=1;
				8'd89:temp<=sda;
				default: if((delay>90))//&&(delay<255)&&(temp==0) 
								begin ack<=2'b10; delay<=8'd0;scl<=0; end
				endcase
				
			else if(ack==2'b10)
				case(delay)
				8'd1 :sda<=1;
				8'd2 :scl<=1;  //scl<=1;
				8'd6 :sda<=0;
				8'd9 :scl<=0;
				8'd11:sda<=1;	//addwr h91 /1
				8'd15:scl<=1;
				8'd19:scl<=0;
				8'd21:sda<=0;  //0		  
				8'd25:scl<=1;
				8'd29:scl<=0;
				8'd31:sda<=0;  //0 
				8'd35:scl<=1;
				8'd39:scl<=0;
				8'd41:sda<=1;  //1
				8'd45:scl<=1; 
				8'd49:scl<=0; 
				8'd51:sda<=0;  //0
				8'd55:scl<=1;
				8'd59:scl<=0;
				8'd61:sda<=0;  //0
				8'd65:scl<=1;
				8'd69:scl<=0;
				8'd71:sda<=0;  //0
				8'd75:scl<=1;
				8'd79:scl<=0;
				8'd81:sda<=1;  //1
				8'd85:scl<=1;
				8'd89:scl<=0;  //end
				8'd91:sda<=1'bz;
				8'd95:scl<=1;
				8'd98:temp<=sda;
				
				default: if((delay>100))// &&(delay<255)&&(temp==0)
								begin ack<=2'b11; delay<=8'd0;// sda<=1'bz;
								scl <=1'b0; end
				endcase
				
			else if(ack==2'b11)    //readADC
				case(delay)
				8'd1 :sda<=1'bz;
				8'd3 :scl<=1;
				8'd5 :data[7]<=sda;	
				8'd8 :scl<=0;				
				8'd13:scl<=1;
				8'd15:data[6]<=sda;
				8'd18:scl<=0;				
				8'd23:scl<=1;
				8'd25:data[5]<=sda;
				8'd28:scl<=0;				
				8'd33:scl<=1;
				8'd35:data[4]<=sda;
				8'd38:scl<=0;				
				8'd43:scl<=1;
				8'd45:data[3]<=sda;
				8'd48:scl<=0;				
				8'd53:scl<=1;
				8'd55:data[2]<=sda;
				8'd58:scl<=0;				
				8'd63:scl<=1;
				8'd65:data[1]<=sda;
				8'd68:scl<=0;				
				8'd73:scl<=1;
				8'd75:data[0]<=sda;
				8'd78:scl<=0;
				8'd80:sda<=0;   //ack 
				8'd83:scl<=1;
				8'd88:scl<=0;   // 确认完毕 
				default: if(delay>90) begin 
							delay<=8'd0;sda<=1'bz; data_out<=data; ack<=2'b01; // xun huan
							//ack<=2'b11;data_out<=data; 有bug   会出现255
							end
				endcase					
		end		
				

endmodule
