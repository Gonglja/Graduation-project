module ReceiveMessage_control(Clk,Rst_n,ReceiveMessage,SetAngleOut);
input Clk;
input Rst_n;
input [23:0]ReceiveMessage;
output [12:0]SetAngleOut;

reg [12:0]setAngle;
always@(posedge Clk or negedge Rst_n)begin
	if(!Rst_n)begin
			setAngle<=13'd90;
		end
	else begin
			//if(ReceiveMessage[23:16]>="0"&&ReceiveMessage[23:16]<="9")setAngle<=ReceiveMessage[23:16]-8'h30;
			setAngle<=(ReceiveMessage[23:16]-8'h30)*100+(ReceiveMessage[15:8]-8'h30)*10+(ReceiveMessage[7:0]-8'h30);
		end
end
assign SetAngleOut=setAngle;
endmodule
