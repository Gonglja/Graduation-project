

module DHT_SEG8(tem_data,DIG,SEG,clk,nRST);
input clk,nRST;
input[39:0] tem_data;
output[7:0] DIG,SEG;
reg [1:0]    SCAN_R;
reg[3:0]    SEG_DR;
reg [7:0]   DIG,SEG;


always @(posedge clk or posedge nRST)
begin

if(nRST)
begin
//tem_data<=0;
DIG = 8'hFF; 
end

else
begin
   SCAN_R = SCAN_R + 1'b1;
   case(SCAN_R)
      3'h0 :
       begin 
       DIG = 8'h7F; 
       SEG_DR = tem_data[39:32]/10;
       case(SEG_DR)
      4'h0 : SEG <= 8'h3F;
      4'h1 : SEG <= 8'h06;
      4'h2 : SEG <= 8'h5B;
      4'h3 : SEG <= 8'h4F;
      4'h4 : SEG <= 8'h66;
      4'h5 : SEG <= 8'h6D;
      4'h6 : SEG <= 8'h7D;
      4'h7 : SEG <= 8'h07;
      4'h8 : SEG <= 8'h7F;
      4'h9 : SEG <= 8'h6F;
      default : SEG <= 8'h00;
      endcase
       
       end
      3'h1 :
       begin DIG = 8'hBF;
       SEG_DR = tem_data[39:32]%10;
       case(SEG_DR)
      4'h0 : SEG <= 8'h3F;
      4'h1 : SEG <= 8'h06;
      4'h2 : SEG <= 8'h5B;
      4'h3 : SEG <= 8'h4F;
      4'h4 : SEG <= 8'h66;
      4'h5 : SEG <= 8'h6D;
      4'h6 : SEG <= 8'h7D;
      4'h7 : SEG <= 8'h07;
      4'h8 : SEG <= 8'h7F;
      4'h9 : SEG <= 8'h6F;
      default : SEG <= 8'h00;
       endcase
      end 
	  3'h2 :
	   begin 
	   DIG = 8'hF7; 
	   SEG_DR = tem_data[23:16]/10;
	   case(SEG_DR)
      4'h0 : SEG <= 8'h3F;
      4'h1 : SEG <= 8'h06;
      4'h2 : SEG <= 8'h5B;
      4'h3 : SEG <= 8'h4F;
      4'h4 : SEG <= 8'h66;
      4'h5 : SEG <= 8'h6D;
      4'h6 : SEG <= 8'h7D;
      4'h7 : SEG <= 8'h07;
      4'h8 : SEG <= 8'h7F;
      4'h9 : SEG <= 8'h6F;
      default : SEG <= 8'h00;
       endcase
	   end
      3'h3 :
       begin 
       DIG = 8'hFB; 
       SEG_DR = tem_data[23:16]%10;
       case(SEG_DR)
      4'h0 : SEG <= 8'h3F;
      4'h1 : SEG <= 8'h06;
      4'h2 : SEG <= 8'h5B;
      4'h3 : SEG <= 8'h4F;
      4'h4 : SEG <= 8'h66;
      4'h5 : SEG <= 8'h6D;
      4'h6 : SEG <= 8'h7D;
      4'h7 : SEG <= 8'h07;
      4'h8 : SEG <= 8'h7F;
      4'h9 : SEG <= 8'h6F;
      default : SEG <= 8'h00;
       endcase
      end
 
   endcase
end
end
endmodule 
