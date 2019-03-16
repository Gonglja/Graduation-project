library verilog;
use verilog.vl_types.all;
entity angle_dale is
    port(
        rx_int          : in     vl_logic;
        rx_data         : in     vl_logic_vector(7 downto 0);
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        angle_g         : out    vl_logic_vector(3 downto 0);
        angle_s         : out    vl_logic_vector(3 downto 0);
        angle_b         : out    vl_logic_vector(3 downto 0);
        angley_g        : out    vl_logic_vector(3 downto 0);
        angley_s        : out    vl_logic_vector(3 downto 0);
        angley_b        : out    vl_logic_vector(3 downto 0);
        anglez_g        : out    vl_logic_vector(3 downto 0);
        anglez_s        : out    vl_logic_vector(3 downto 0);
        anglez_b        : out    vl_logic_vector(3 downto 0)
    );
end angle_dale;
