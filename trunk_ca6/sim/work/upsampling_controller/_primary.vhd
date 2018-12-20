library verilog;
use verilog.vl_types.all;
entity upsampling_controller is
    port(
        clk             : in     vl_logic;
        start           : in     vl_logic;
        cmp1            : in     vl_logic;
        cmp2            : in     vl_logic;
        cmp3            : in     vl_logic;
        cmp4            : in     vl_logic;
        reset           : in     vl_logic;
        clear           : out    vl_logic;
        rset3           : out    vl_logic;
        inc1            : out    vl_logic;
        inc2            : out    vl_logic;
        inc3            : out    vl_logic;
        enr1            : out    vl_logic;
        enr2            : out    vl_logic;
        enr3            : out    vl_logic;
        enr4            : out    vl_logic;
        enr5            : out    vl_logic;
        enr6            : out    vl_logic;
        r1_5mux         : out    vl_logic;
        r6mux           : out    vl_logic;
        wmux            : out    vl_logic;
        wren            : out    vl_logic;
        done            : out    vl_logic
    );
end upsampling_controller;
