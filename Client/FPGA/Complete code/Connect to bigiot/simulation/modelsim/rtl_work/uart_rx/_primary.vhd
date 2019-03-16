library verilog;
use verilog.vl_types.all;
entity uart_rx is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        rx_int          : out    vl_logic;
        data_rd         : in     vl_logic;
        dataout         : out    vl_logic_vector(7 downto 0)
    );
end uart_rx;
