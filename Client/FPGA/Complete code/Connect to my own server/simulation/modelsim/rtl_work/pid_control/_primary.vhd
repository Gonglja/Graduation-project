library verilog;
use verilog.vl_types.all;
entity pid_control is
    port(
        Clk             : in     vl_logic;
        Rst_n           : in     vl_logic;
        setAngle        : in     vl_logic_vector(12 downto 0);
        CurrentAngle    : in     vl_logic_vector(12 downto 0);
        CurrentGyro     : in     vl_logic_vector(12 downto 0);
        ResultOut_l     : out    vl_logic_vector(15 downto 0);
        ResultOut_r     : out    vl_logic_vector(15 downto 0)
    );
end pid_control;
