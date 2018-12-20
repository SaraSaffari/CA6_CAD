library verilog;
use verilog.vl_types.all;
entity yuv_to_rgb_datapath is
    generic(
        WRITE_ADDR_BASE : integer := 115200;
        READ_ADDR_BASE  : integer := 0;
        W               : integer := 320;
        H               : integer := 240
    );
    port(
        clk             : in     vl_logic;
        clear           : in     vl_logic;
        rdata           : in     vl_logic_vector(15 downto 0);
        eny1            : in     vl_logic;
        enu1            : in     vl_logic;
        env1            : in     vl_logic;
        eny2            : in     vl_logic;
        enu2            : in     vl_logic;
        env2            : in     vl_logic;
        smuxra          : in     vl_logic_vector(1 downto 0);
        smuxop1         : in     vl_logic_vector(1 downto 0);
        smuxop2         : in     vl_logic;
        smuxop3         : in     vl_logic;
        inc1            : in     vl_logic;
        inc2            : in     vl_logic;
        cmp             : out    vl_logic;
        waddr           : out    vl_logic_vector(17 downto 0);
        wdata           : out    vl_logic_vector(15 downto 0);
        raddr           : out    vl_logic_vector(17 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WRITE_ADDR_BASE : constant is 1;
    attribute mti_svvh_generic_type of READ_ADDR_BASE : constant is 1;
    attribute mti_svvh_generic_type of W : constant is 1;
    attribute mti_svvh_generic_type of H : constant is 1;
end yuv_to_rgb_datapath;
