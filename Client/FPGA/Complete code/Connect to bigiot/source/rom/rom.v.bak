module rom(clk_sys,rst_n,q);
input clk_sys,rst_n;
output [7:0]q;

wire [7:0]address;
rom_control U1(
				.clk_sys(clk_sys),
				.rst_n(rst_n),
				.address(address)
);

my_rom U2(
				.address(address),
				.clock(clk_sys),
				.q(q)
);

endmodule

