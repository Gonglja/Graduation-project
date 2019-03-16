module esp8266_encode(Clk,Rst_n,Sig,inputData,Data_send);
input Clk,Rst_n;
input [31:0]inputData;
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
			0 :begin data_send[7:0]<="m" ;   state<=state+1'b1;end
			1 :begin data_send[7:0]<="(" ;   state<=state+1'b1;end
			2 :begin data_send[7:0]<="\"";   state<=state+1'b1;end
			3 :begin data_send[7:0]<=inputData[31:24];   state<=state+1'b1;end
			4 :begin data_send[7:0]<="\"";   state<=state+1'b1;end
			5 :begin data_send[7:0]<="," ;   state<=state+1'b1;end
			6 :begin data_send[7:0]<="\"" ;  state<=state+1'b1;end
			7 :begin data_send[7:0]<=inputData[23:16]+8'h30;state<=state+1'b1;end
			8 :begin data_send[7:0]<=inputData[15:8]+8'h30;state<=state+1'b1;end
			9 :begin data_send[7:0]<=".";    state<=state+1'b1;end
			10:begin data_send[7:0]<=inputData[7:0]+8'h30;state<=state+1'b1;end
			11:begin data_send[7:0]<="\"";   state<=state+1'b1;end
			12:begin data_send[7:0]<=")";    state<=state+1'b1;end
			13:begin data_send[7:0]<="\r";   state<=state+1'b1;end
			14:begin data_send[7:0]<="\n";   state<=state+1'b1;end
			15:begin data_send[7:0]<="\n";   send_done <= 1;end
			default:state<=state+1'b1;
			endcase
		end                         
end
assign Sig=sig;
assign Data_send[7:0]=data_send[7:0];
endmodule
