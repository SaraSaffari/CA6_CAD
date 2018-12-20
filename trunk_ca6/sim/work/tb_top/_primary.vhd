library verilog;
use verilog.vl_types.all;
entity tb_top is
    generic(
        IMAGE_WIDTH     : integer := 320;
        IMAGE_HEIGHT    : integer := 240;
        SRAM_INIT_SIZE  : vl_notype;
        INIT_FILE_NAME  : string  := "./file/ca5_wallpaper.hex";
        SRAM_INIT_START : integer := 0;
        UPSAMPLE_READ_ADDR_BASE: integer := 0;
        UPSAMPLE_WRITE_ADDR_BASE: integer := 115200;
        CONVERSION_READ_ADDR_BASE: vl_notype;
        CONVERSION_WRITE_ADDR_BASE: vl_notype;
        AW              : integer := 18;
        DW              : integer := 16
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IMAGE_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of IMAGE_HEIGHT : constant is 1;
    attribute mti_svvh_generic_type of SRAM_INIT_SIZE : constant is 3;
    attribute mti_svvh_generic_type of INIT_FILE_NAME : constant is 1;
    attribute mti_svvh_generic_type of SRAM_INIT_START : constant is 1;
    attribute mti_svvh_generic_type of UPSAMPLE_READ_ADDR_BASE : constant is 1;
    attribute mti_svvh_generic_type of UPSAMPLE_WRITE_ADDR_BASE : constant is 1;
    attribute mti_svvh_generic_type of CONVERSION_READ_ADDR_BASE : constant is 3;
    attribute mti_svvh_generic_type of CONVERSION_WRITE_ADDR_BASE : constant is 3;
    attribute mti_svvh_generic_type of AW : constant is 1;
    attribute mti_svvh_generic_type of DW : constant is 1;
end tb_top;
