library verilog;
use verilog.vl_types.all;
entity esp8266_decode is
    port(
        rx_int          : in     vl_logic;
        rx_data         : in     vl_logic_vector(7 downto 0);
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        data            : out    vl_logic_vector(23 downto 0)
    );
end esp8266_decode;
