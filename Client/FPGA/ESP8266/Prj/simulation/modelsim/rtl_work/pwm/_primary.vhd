library verilog;
use verilog.vl_types.all;
entity pwm is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        PWM_duty        : in     vl_logic_vector(15 downto 0);
        PWM_prec        : in     vl_logic_vector(15 downto 0);
        PWM_freq        : in     vl_logic_vector(15 downto 0);
        PWM_out         : out    vl_logic
    );
end pwm;
