module esp8266_encode(Clk,Rst_n,Sig,Data_send);
input Clk,Rst_n;
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
reg [8*13:1]str;
reg [8*46:1]str1;
reg [8*14:1]str2;
always@(posedge sig or negedge Rst_n)begin
	if(!Rst_n)begin
			state <= 16'd70;
			send_done <= 0;
			str="AT+CWMODE=1\r\n";
			str1="AT+CWJAP=\"Power Laboratory 1221\",\"Dldz1221!\"\r\n";//46
			str2="AT+CIPMODE=1\r\n";
			//datasend_esp8266<=0;
		end
	else begin
			case(state)
			//0,1,2,3,4,5,6,7,8,9,10,11,12:begin data_send<=str[8*13:8*12+1];str = str << 8;state<=state+1;end
			//13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58:begin data_send<=str1[8*46:8*45+1];str1 = str1 << 8;state<=state+1;end
			16'd70:begin str1="AT+CIPSTART=\"TCP\",\"www.bigiot.net\",8181\r\n";state<=state+1'b1;end

			100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 
			120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 
			140, 141, 142, 143, 144, 145:begin data_send<=str1[8*46:8*45+1];str1 = str1 << 8;state<=state+1;end
			146:begin data_send<=" ";state<=state+1'b1;end
			199:begin data_send<="\n";state<=state+1'b1;end
			
			200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213:begin data_send<=str2[8*14:8*13+1];str2 = str2 << 8;state<=state+1'b1;end
			214:begin data_send<=" ";state<=state+1'b1;end
			
			250:begin str2="\r\nAT+CIPSEND\r\n";state<=state+1'b1;end
			299:begin data_send<="\n";state<=state+1'b1;end
			
			300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313:begin data_send<=str2[8*14:8*13+1];str2 = str2 << 8;state<=state+1;end
			314:begin data_send<=" ";state<=state+1'b1;end
	
			350:begin str1="{\"M\":\"checkin\",\"ID\":\"7351\",\"K\":\"87a5ff0d9\"}\r\n\n";state<=state+1;end
			399:begin data_send<="\n";state<=state+1'b1;end
			
			400, 401, 402, 403, 404, 405, 406, 407, 408, 409,410, 411, 412, 413, 414, 415, 416, 417, 418, 419, 
			420, 421, 422, 423, 424, 425, 426, 427, 428, 429,430, 431, 432, 433, 434, 435, 436, 437, 438, 439, 
			440, 441, 442, 443, 444, 445:begin data_send<=str1[8*46:8*45+1];str1 = str1 << 8;state<=state+1'b1;end
			446:begin data_send<=" ";state<=state+1'b1;end
			//450:begin str2="{\"M\":\"beat\"}\r\n";state<=state+1'b1;send_done <= 1;end
			
			5196:begin state<=350;end//发送开始
			//5197:begin data_send<="\n";state<=state+1'b1;end
			
			//5198,5199,5120,5121,5122,5123,5124,5125,5126,5127,5128,5129,5130,5131,5132,5133:begin data_send<=str2[8*14:8*13+1];str2 = str2 << 8;state<=state+1'b1;end
			//5134:state=446;
			default:state<=state+1'b1;
			endcase
		end                         
end
assign Sig=sig;
assign Data_send[7:0]=data_send[7:0];
endmodule
