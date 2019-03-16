library verilog;
use verilog.vl_types.all;
entity uart_tx is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        data_wr         : out    vl_logic;
        wrsig           : in     vl_logic;
        datain          : in     vl_logic_vector(7 downto 0)
    );
end uart_tx;
