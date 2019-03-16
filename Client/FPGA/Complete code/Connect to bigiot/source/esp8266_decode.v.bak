module w_dale
	(	rx_int,rx_data,clk,rst,
		wx_g,wx_s,wx_b,
		wy_g,wy_s,wy_b,
		wz_g,wz_s,wz_b
	);

input clk,rst,rx_int;
input [7:0] rx_data;

output wire[3:0] wx_g,wx_s,wx_b,wy_g,wy_s,wy_b,wz_g,wz_s,wz_b;

reg[3:0] count;

reg [47:0]w;
wire [15:0] wx_dat;//,wy_dat,wz_dat;
reg [15:0] chang_x;//,chang_y,chang_z;
reg flag;

always@(posedge clk or negedge rst)
	begin
		if(!rst)
			flag<=0;
		else
			begin
				if(rx_data==8'h52)
					flag<=1;
				if(count>=6)
					flag<=0;
			end
	end

always@(negedge rx_int or negedge rst)
	begin
		if(!rst)
			begin
				count<=0;
			end
		else
			begin
				if(flag)
					begin
						if(count>=6)
							count<=0;
						else 
							count<=count+1;
					end
				else
					count<=0;
			end
	end
/***************************************************
*********************读取角度************************
****************************************************/
always@(negedge clk or negedge rst)
	begin
		if(!rst)
			begin
				w<=0;
			end
		else
			begin
				case(count)
					4'd1:w[47:40]<=rx_data;
					4'd2:w[39:32]<=rx_data;
					4'd3:w[31:24]<=rx_data;
					4'd4:w[23:16]<=rx_data;
					4'd5:w[15:8]<=rx_data;
					4'd6:w[7:0]<=rx_data;
					default:w<=w;
				endcase
			end
	end
/***************************************************
**************求出真实的角度（x轴）********************
****************************************************/
always@(*)
	begin
		chang_x=(w[39:32]<<8)|w[47:40];
		if(chang_x>=32768)
			chang_x=16'hffff+1'b1-chang_x;
		else
			chang_x=chang_x; 
	end

/***************************************************
**************求出真实的角度（y轴）********************
****************************************************/
	
//always@(*)
//	begin
//		chang_y=(w[23:16]<<8)|w[31:24];
//		if(chang_y>=32768)
//			chang_y=16'hffff+1'b1-chang_y;
//		else
//			chang_y=chang_y; 
//	end	
//	
/***************************************************
**************求出真实的角度（z轴）********************
****************************************************/
//always@(*)
//	begin
//		chang_z=(w[7:0]<<8)|w[15:8];
//		if(chang_z>=32768)
//			chang_z=16'hffff+1'b1-chang_z;
//		else
//			chang_z=chang_z; 
//	end	
//	
assign wx_dat=((chang_x)*100)/32768*2000/100;	
assign wx_g=wx_dat%10;
assign wx_s=wx_dat%100/10;
assign wx_b=wx_dat/100;

//assign wy_dat=((chang_y)*100)/32768*2000/100;	
//assign wy_g=wy_dat%10;
//assign wy_s=wy_dat%100/10;
//assign wy_b=wy_dat/100;
//
//assign wz_dat=((chang_z)*100)/32768*2000/100;	
//assign wz_g=wz_dat%10;
//assign wz_s=wz_dat%100/10;
//assign wz_b=wz_dat/100;

endmodule
