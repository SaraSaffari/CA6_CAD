library verilog;
use verilog.vl_types.all;
entity upsampling_top is
    generic(
        W               : integer := 320;
        H               : integer := 240;
        DW              : integer := 16;
        AW              : integer := 18;
        WRITE_ADDR_BASE : integer := 115200;
        READ_ADDR_BASE  : integer := 0
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        start           : in     vl_logic;
        done            : out    vl_logic;
        raddr           : out    vl_logic_vector;
        rdata           : in     vl_logic_vector;
        waddr           : out    vl_logic_vector;
        wdata           : out    vl_logic_vector;
        wr_enable       : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of W : constant is 1;
    attribute mti_svvh_generic_type of H : constant is 1;
    attribute mti_svvh_generic_type of DW : constant is 1;
    attribute mti_svvh_generic_type of AW : constant is 1;
    attribute mti_svvh_generic_type of WRITE_ADDR_BASE : constant is 1;
    attribute mti_svvh_generic_type of READ_ADDR_BASE : constant is 1;
end upsampling_top;
