library verilog;
use verilog.vl_types.all;
entity w_dale is
    port(
        rx_int          : in     vl_logic;
        rx_data         : in     vl_logic_vector(7 downto 0);
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        wx_g            : out    vl_logic_vector(3 downto 0);
        wx_s            : out    vl_logic_vector(3 downto 0);
        wx_b            : out    vl_logic_vector(3 downto 0);
        wx_f            : out    vl_logic;
        wy_g            : out    vl_logic_vector(3 downto 0);
        wy_s            : out    vl_logic_vector(3 downto 0);
        wy_b            : out    vl_logic_vector(3 downto 0);
        wz_g            : out    vl_logic_vector(3 downto 0);
        wz_s            : out    vl_logic_vector(3 downto 0);
        wz_b            : out    vl_logic_vector(3 downto 0)
    );
end w_dale;
