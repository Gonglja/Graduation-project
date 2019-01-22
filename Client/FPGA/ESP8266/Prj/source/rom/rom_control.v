module rom_control(clk_sys,rst_n,address);
input clk_sys,rst_n;
output reg[7:0]address;

always@(posedge clk_sys or negedge rst_n)begin
	if(!rst_n)begin
		address <= "0";
	end
	else begin
//		if(address == "Z")
//			address <= "0";
//		else
			address <= "Z"-1;
//		if(address >= 256)
//			address <= 0;
//		else
//			address <= address + 1;
	end


end

endmodule
