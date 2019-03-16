library verilog;
use verilog.vl_types.all;
entity clk_set is
    port(
        clk_sys         : in     vl_logic;
        rst_n           : in     vl_logic;
        baud            : in     vl_logic_vector(15 downto 0);
        clk             : out    vl_logic
    );
end clk_set;
