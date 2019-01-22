library verilog;
use verilog.vl_types.all;
entity ReceiveMessage_control is
    port(
        Clk             : in     vl_logic;
        Rst_n           : in     vl_logic;
        ReceiveMessage  : in     vl_logic_vector(23 downto 0);
        SetAngleOut     : out    vl_logic_vector(12 downto 0)
    );
end ReceiveMessage_control;
