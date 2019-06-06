module esp8266_encode(Clk,Rst_n,Sig,iTeData,iHuData,iSmData,Data_send);
input Clk,Rst_n;
input [23:0]iTeData;
input [15:0]iHuData;
input [15:0]iSmData;
output Sig;
output [7:0]Data_send;

reg sig;

reg [23:0]cnt;
always@(posedge Clk or negedge Rst_n)begin
		if(!Rst_n)begin
				sig <= 1'b0;
				cnt <= 15'd0;
			end
		else if(cnt == 24'd2500 -1)begin
				sig <= 1'b1;
				cnt <= cnt + 1'b1;
			end
		else if(cnt == 24'd5000 -1)begin
				sig <= 1'b0;
				cnt <= 24'd0;
			end
		else if(send_done)begin
				sig <= 1'b0;
			end
		else begin
				cnt <= cnt + 1'b1;
			end
end	

reg [15:0]state;
reg [7:0]data_send;
reg send_done;
//reg [8*15:1]str;

//定时发送
reg [19:0]cccc;
reg clk_nRST;
always @(posedge Clk or negedge Rst_n )begin
	if(!Rst_n)begin
		cccc <= 20'd0;
	   clk_nRST <= 0;	
	end
	else begin
		if((cccc ==20'd2000000 -1 )&&(send_done==1'b1))begin
		   cccc <= 20'd0;
			clk_nRST <=0;
		end 
		else begin
			cccc <= cccc + 1'b1;
			clk_nRST <= 1;
		end
	end
end


always@(posedge sig or negedge clk_nRST)begin
	if(!clk_nRST)begin
			state <= 16'd0;
			send_done <= 0;
		end
	else begin
			case(state)
			
			//m(\"T\",\"12.5\")\r\n
			//m(\"12.5\",\"12\",\"12\")\r\n
			0 :begin data_send[7:0]<="m" ;   state<=state+1'b1;end
			1 :begin data_send[7:0]<="(" ;   state<=state+1'b1;end
			2 :begin data_send[7:0]<="\"";   state<=state+1'b1;end
			//3 :begin data_send[7:0]<=inputData[31:24];   state<=state+1'b1;end
			3 :begin data_send[7:0]<=iTeData[23:16];state<=state+1'b1;end
			4 :begin data_send[7:0]<=iTeData[15:8];state<=state+1'b1;end
			5 :begin data_send[7:0]<=".";    state<=state+1'b1;end
			6 :begin data_send[7:0]<=iTeData[7:0];state<=state+1'b1;end
			
			7 :begin data_send[7:0]<="\"";   state<=state+1'b1;end
			8 :begin data_send[7:0]<="," ;   state<=state+1'b1;end
			9 :begin data_send[7:0]<="\"" ;  state<=state+1'b1;end
			10:begin data_send[7:0]<=iHuData[15:8];state<=state+1'b1;end
			11:begin data_send[7:0]<=iHuData[7:0];state<=state+1'b1;end
			12 :begin data_send[7:0]<="\"";   state<=state+1'b1;end
			13 :begin data_send[7:0]<="," ;   state<=state+1'b1;end
			
			14 :begin data_send[7:0]<="\"" ;  state<=state+1'b1;end
			15:begin data_send[7:0]<=iSmData[15:8];state<=state+1'b1;end
			16:begin data_send[7:0]<=iSmData[7:0];state<=state+1'b1;end
			17 :begin data_send[7:0]<="\"" ;  state<=state+1'b1;end
			
			18:begin data_send[7:0]<=")";    state<=state+1'b1;end
			19:begin data_send[7:0]<="\r";   state<=state+1'b1;end
			20:begin data_send[7:0]<="\n";   state<=state+1'b1;end
			21:begin data_send[7:0]<="\n";   send_done <= 1;end
			default:state<=state+1'b1;
			endcase
		end                         
end
assign Sig=sig;
assign Data_send[7:0]=data_send[7:0];
endmodule
