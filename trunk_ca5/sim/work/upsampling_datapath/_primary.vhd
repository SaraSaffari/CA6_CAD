library verilog;
use verilog.vl_types.all;
entity upsampling_datapath is
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
        clear           : in     vl_logic;
        rset3           : in     vl_logic;
        rdata           : in     vl_logic_vector;
        enr1            : in     vl_logic;
        enr2            : in     vl_logic;
        enr3            : in     vl_logic;
        enr4            : in     vl_logic;
        enr5            : in     vl_logic;
        enr6            : in     vl_logic;
        inc1            : in     vl_logic;
        inc2            : in     vl_logic;
        inc3            : in     vl_logic;
        r1_5mux         : in     vl_logic;
        r6mux           : in     vl_logic;
        wmux            : in     vl_logic;
        cmp1            : out    vl_logic;
        cmp2            : out    vl_logic;
        cmp3            : out    vl_logic;
        cmp4            : out    vl_logic;
        waddr           : out    vl_logic_vector;
        wdata           : out    vl_logic_vector;
        raddr           : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of W : constant is 1;
    attribute mti_svvh_generic_type of H : constant is 1;
    attribute mti_svvh_generic_type of DW : constant is 1;
    attribute mti_svvh_generic_type of AW : constant is 1;
    attribute mti_svvh_generic_type of WRITE_ADDR_BASE : constant is 1;
    attribute mti_svvh_generic_type of READ_ADDR_BASE : constant is 1;
end upsampling_datapath;
