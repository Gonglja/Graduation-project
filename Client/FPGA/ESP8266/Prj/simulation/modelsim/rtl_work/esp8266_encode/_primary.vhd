library verilog;
use verilog.vl_types.all;
entity esp8266_encode is
    port(
        Clk             : in     vl_logic;
        Rst_n           : in     vl_logic;
        Sig             : out    vl_logic;
        Data_send       : out    vl_logic_vector(7 downto 0)
    );
end esp8266_encode;
