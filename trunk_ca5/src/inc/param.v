parameter IMAGE_WIDTH = 320;
parameter IMAGE_HEIGHT = 240;

parameter SRAM_INIT_SIZE = IMAGE_WIDTH*IMAGE_HEIGHT;
parameter INIT_FILE_NAME = "./file/ca5_wallpaper.hex";
parameter SRAM_INIT_START = 0;

parameter UPSAMPLE_READ_ADDR_BASE  = 0 ;
parameter UPSAMPLE_WRITE_ADDR_BASE = 115200;

parameter CONVERSION_READ_ADDR_BASE  = UPSAMPLE_WRITE_ADDR_BASE ;
parameter CONVERSION_WRITE_ADDR_BASE = UPSAMPLE_READ_ADDR_BASE;