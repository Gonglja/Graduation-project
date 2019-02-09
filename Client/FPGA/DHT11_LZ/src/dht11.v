//==========================================================================
//company   :NanJingUniversity JiLing College
//Filename  :dht11.v
//modulename:dht11
//Author    :moyunjie
//Date	    :2016-1-13
//Function  :��ʪ�ȼ�dht11�����ݲɼ����ɼ����1s
//==========================================================================
module dht11(
						i_clk,
						i_rst_n,
						io_data,
						o_temp,
						o_humi
							);

input i_clk;//50mhz
input i_rst_n;//�͵�ƽ��λ
inout io_data;//���ݶ˿�
output reg [7:0]o_temp;//����¶�
output reg [7:0]o_humi;//���ʪ��
reg o_data;//�������



reg [39:0]get_data;//dht11��ȡ������
reg [5:0]data_num;//��ȡ���ݵ�λ��
reg[3:0]crt_state;//����״̬��
reg [3:0]next_state;
parameter idle		= 4'b0001;//����״̬
parameter init		= 4'b0010;//��������λ״̬
parameter ans 		= 4'b0100;//�ӻ�Ӧ��
parameter rd_data	= 4'b1000;//��������
/////////============״̬��
always@(posedge i_clk or negedge i_rst_n )
				if(!i_rst_n)
						crt_state<=idle;
				else
						crt_state<=next_state;


reg data_sam1;//�������1
reg data_sam2;//�������2

reg data_pluse;//�����������������
always@(posedge i_clk )
begin
	data_sam1<=io_data;
	data_sam2<=data_sam1;
	data_pluse<=(~data_sam2)&data_sam1;
end
reg[26:0] cnt_1s;//1s������  
always@(posedge i_clk or negedge i_rst_n )
	if(!i_rst_n)
		cnt_1s<=27'd0;	
	else if(cnt_1s==27'd49999999)
		cnt_1s<=27'd0;
	else
		cnt_1s<=cnt_1s+1'b1;
/////////============״̬��	
always@( *) 
		case(crt_state)
				idle:if(cnt_1s==27'd49999999)//1s��ʼ����
								next_state=init;
							else
								next_state=crt_state;
				
				init:if(cnt_1s>=27'd1002000 )//20ms+40us
								next_state=ans;
							else
								next_state=crt_state;
				
				ans:	if(data_pluse)//��⵽������
								next_state=rd_data;
							else
								next_state=crt_state;
				
				rd_data:if(data_num==6'd40)//�յ�40λ����
									next_state=idle;
								else
									next_state=crt_state;
				default:next_state=idle;
		endcase
		
reg [12:0]cnt_40us;//40us������
reg send_indi;//�������ָʾ
reg r_hold;//ά��40us
always@(posedge i_clk )
	if(crt_state[1] && (cnt_1s<=27'd1000000))//����20ms��>18ms���͵�ƽ
		begin
			o_data<=1'b0;
			send_indi<=1'b1;
		end
	else if(crt_state[1])//�ȴ�40us����ƽ����
		begin
			o_data<=1'b1;
			send_indi<=1'b0;
		end
	else if(crt_state[2] & data_pluse)//��⵽dht����
		begin
			data_num<=6'd0;
		end
	else if(crt_state[3] & (data_pluse | r_hold))//��������
				begin
					r_hold<=1'b1;
					cnt_40us<=cnt_40us+1'b1;
					if(cnt_40us==12'd2000)//���ߵ͵�ƽ�ȴ�40us��28<40<70���ټ��ߵ͵�ƽ
						begin
							r_hold<=1'b0;
							if(io_data)
									get_data<={get_data[38:0],1'b1};
							else
								   get_data<={get_data[38:0],1'b0}; 
							cnt_40us<=12'd0;
							data_num<=data_num+1'b1;
						end
				end
	else
		begin
			if(data_num==6'd40)//��ʪ�ȸ�ֵ
				begin
					o_humi<=get_data[39:32];
					o_temp<=get_data[23:16];
				end
		end		

assign io_data =send_indi ? o_data : 1'bz;//˫��˿�

endmodule
			 
		
		
		
		

