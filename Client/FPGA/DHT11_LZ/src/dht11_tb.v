`timescale 1ns / 1ps

module dht11_tb ;

	localparam			IDLE			=	16'h0000	,
						M_STAR			=	16'h0001	,	// 主机拉低（开始信号） >=18ms+(20us/40us)
						DHT11_RSP		=	16'h0004	,	// DHT11应答
						RSP_DELAY		=	16'h0008	,	// DHT11应答延时 80us
						DHT11_HIGHT 	=	16'h0010	,	// DHT11拉高
						DHT11_DELAY 	=	16'h0020	,	// DHT11拉高延时 80us
						DATA_START		= 	16'h0040	,	// 数据开始
						DATA_DELAY		= 	16'h0080	,	// 数据来临延时 50us
						DATA_DEAL		= 	16'h0100	,	// 数据获取  
						DATA_OPINION	= 	16'h0200	,	// 数据获取 1(70us)，0(26us-28us)
						DATA_GET		=	16'h0400	,
						FINISH			=	16'h0800	;
	reg			clk_50m						;
	reg			rst_n						;
	wire		dht11_io					;
	wire [15:0]	data_state					;
	
	reg 		dht11_io_en;
	reg 		dht11_io_in;
	reg 		dht11_io_out_reg;
	
	assign dht11_io = dht11_io_en ? dht11_io_in : 1'dz ;
	
	initial begin
		clk_50m	 = 1'd0 ;
		rst_n	 = 1'd0 ;
		dht11_io_en = 1'd0 ;
		dht11_io_in = 1'd0 ;
	
		#1000 rst_n = 1'd1 ;
	end
	
	always @(posedge clk_50m or negedge rst_n) begin
		if(!rst_n) begin
			dht11_io_out_reg <= 1'd0;
		end
		else begin
			dht11_io_out_reg <= dht11_io ;
		end
	end
	
	reg [7:0 ] 	data_state_tb;
	reg [15:0]	delay_cnt;
	
	
	always @(posedge clk_50m or negedge rst_n) begin
		if(!rst_n) begin
			dht11_io_en <= 1'd0;
			dht11_io_in <= 1'd0;
		end
		else begin
			case (data_state) 
				DHT11_RSP : begin
					dht11_io_en <= 1'd1;
					dht11_io_in <= 1'd0;
				end
				DHT11_HIGHT : begin
					dht11_io_en <= 1'd1;
					dht11_io_in <= 1'd1;
				end
				DATA_START : begin
					dht11_io_en <= 1'd1;
					dht11_io_in <= 1'd0;
				end
				DATA_DEAL : begin
					dht11_io_en <= 1'd1;
					dht11_io_in <= 1'd1;
				end
				DATA_OPINION : begin
					if(delay_cnt == 16'd3500) begin
						dht11_io_en <= 1'd1;
						dht11_io_in <= 1'd0;
					end
					else begin
						dht11_io_en <= 1'd1;
						dht11_io_in <= 1'd1;
					end
				end
				default : begin
					dht11_io_en <= dht11_io_en;
					dht11_io_in <= dht11_io_in;
				end
			endcase 
		end
	end
	
	always #10 clk_50m = ~clk_50m ;
	
	always @(posedge clk_50m or negedge rst_n) begin
		if(!rst_n)begin
			delay_cnt <= 16'd0 ;
		end
		else begin
			case (data_state)
				DATA_OPINION	: 	delay_cnt <= delay_cnt + 1'd1 ;
				default			:   delay_cnt <= 16'd0 ;
			endcase
		end
	end
	
	dht11 dht11 
	(
		.clk_50m					(clk_50m	),
		.rst_n						(rst_n		),
		.dht11_io					(dht11_io	),
		.data_state					(data_state)
	);
endmodule 