module display(clk,num, dig_sel, en_o, dig_num);
	input clk;
	output en_o; 
	input [7:0]num; 
	output [2:0]dig_sel;
	output [7:0]dig_num;	
	wire en_o =1;	
	reg [7:0]dig_num;
	
//----------------------------------
   reg[23:0] counter;    
   always@(posedge clk)
		counter <= counter + 1'b1; // ji man le hui qing ling
	assign dig_sel = {1'b0,counter[18:17]};
	
	reg [3:0] bcd;
	always@(*)
		begin
			case(counter[18:17])
		/*	3'b111: bcd=num[31:0]/10000000;
			3'b110: bcd=num[31:0]%10000000/1000000;
			3'b101: bcd=num[31:0]%1000000/100000;
			3'b100: bcd=num[31:0]%100000/10000; */
			2'b11: bcd<=num/1000;  
			2'b10: bcd<=num%1000/100;
			2'b01: bcd<=num%100/10;
			2'b00: bcd<=num%10;
			default: ;
			endcase	
		end
	
	always@(bcd) // bcd 
		begin 
			case(bcd)
			4'h0 : dig_num <= 8'b00000011;
			4'h1 : dig_num <= 8'b10011111;
			4'h2 : dig_num <= 8'b00100101;
			4'h3 : dig_num <= 8'b00001101;
			4'h4 : dig_num <= 8'b10011001;
			4'h5 : dig_num <= 8'b01001001;
			4'h6 : dig_num <= 8'b01000001;
			4'h7 : dig_num <= 8'b00011111;
			4'h8 : dig_num <= 8'b00000001;
			4'h9 : dig_num <= 8'b00001001;	
			default: ;
			endcase					
		end

endmodule 