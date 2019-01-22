library verilog;
use verilog.vl_types.all;
entity top is
    generic(
        BPS_9600        : vl_logic_vector(0 to 15) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi1, Hi0, Hi0, Hi0, Hi1, Hi0, Hi1);
        BPS_115200      : vl_logic_vector(0 to 15) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi0, Hi1, Hi1);
        duty            : integer := 7500;
        prec            : integer := 10000;
        freq            : integer := 500
    );
    port(
        clk_sys         : in     vl_logic;
        rst_n           : in     vl_logic;
        rx_mpu6050      : in     vl_logic;
        rx_esp8266      : in     vl_logic;
        tx_esp8266      : out    vl_logic;
        lcd_rs          : out    vl_logic;
        lcd_en          : out    vl_logic;
        lcd_rw          : out    vl_logic;
        lcd_data        : out    vl_logic_vector(7 downto 0);
        pwm_l           : out    vl_logic;
        pwm_r           : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of BPS_9600 : constant is 1;
    attribute mti_svvh_generic_type of BPS_115200 : constant is 1;
    attribute mti_svvh_generic_type of duty : constant is 1;
    attribute mti_svvh_generic_type of prec : constant is 1;
    attribute mti_svvh_generic_type of freq : constant is 1;
end top;
