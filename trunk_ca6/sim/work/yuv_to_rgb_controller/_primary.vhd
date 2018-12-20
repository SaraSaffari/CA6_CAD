library verilog;
use verilog.vl_types.all;
entity yuv_to_rgb_controller is
    port(
        clk             : in     vl_logic;
        start           : in     vl_logic;
        cmp             : in     vl_logic;
        clear           : out    vl_logic;
        eny1            : out    vl_logic;
        enu1            : out    vl_logic;
        env1            : out    vl_logic;
        eny2            : out    vl_logic;
        enu2            : out    vl_logic;
        env2            : out    vl_logic;
        smuxra          : out    vl_logic_vector(1 downto 0);
        smuxop1         : out    vl_logic_vector(1 downto 0);
        smuxop2         : out    vl_logic;
        smuxop3         : out    vl_logic;
        inc1            : out    vl_logic;
        inc2            : out    vl_logic;
        wren            : out    vl_logic;
        done            : out    vl_logic
    );
end yuv_to_rgb_controller;
