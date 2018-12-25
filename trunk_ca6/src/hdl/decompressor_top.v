// `default_nettype none
module decompressor_top#(
		parameter AW = 18,
		parameter DW = 16,
		parameter IMAGE_WIDTH = 320,
		parameter IMAGE_HEIGHT = 240,
		parameter CONVERSION_WRITE_ADDR_BASE = 115200,
		parameter CONVERSION_READ_ADDR_BASE = 0,
		parameter UPSAMPLE_WRITE_ADDR_BASE = 0,
		parameter UPSAMPLE_READ_ADDR_BASE = 0
		)
	(
		input wire reset,
		input wire clk,
		
		input wire start, 
		output wire done,
		
		// *********** SRAM Interface Signals ****************************
		// Read-only port
		output reg [AW-1:0]	sram_raddr,
		input wire [DW-1:0] sram_rdata,
		// Write-only port
		output reg [AW-1:0]	sram_waddr,
		output reg [DW-1:0]	sram_wdata,
		output reg 			sram_wr_enable,
		// ************* VGA Controller Interface Signals *****************
		output wire vgastart,
		output wire [7:0] r,
		output wire [7:0] g,
		output wire [7:0] b
	);	
	
	
	
	// ======================= Define internal signals ==========================
		
	
	// ***** signal for sram_vga_controller *****
	wire [AW-1:0]	sram_vga_raddr;
	wire [DW-1:0]	sram_vga_rdata;
	reg				sram_vga_start;
	// Write-only port
	wire [AW-1:0]	sram_vga_waddr;
	wire [DW-1:0]	sram_vga_wdata;
	wire 			sram_vga_wr_enable;
	
	// ***** signal for conversion_pixel *****
	wire 			conversion_done;
	reg 			conversion_start;
	wire [AW-1:0]	conversion_raddr;
	wire [DW-1:0]	conversion_rdata;
	
	// Write-only port
	wire [AW-1:0]	conversion_waddr;
	wire [DW-1:0]	conversion_wdata;
	wire 			conversion_wr_enable;
	
	// ***** signal for upsampling *****
	// Read-only port
	wire 			upsample_done;
	wire 			upsample_start;
	wire [AW-1:0]	upsample_raddr;
	wire [DW-1:0]	upsample_rdata;
	
	// Write-only port
	wire [AW-1:0]	upsample_waddr;
	wire [DW-1:0]	upsample_wdata;
	wire 			upsample_wr_enable;
	
	// **** signal for dct_inverse ****  
	// Read-only port
	wire			dct_inverse_done;
	wire [AW-1:0] 	dct_inverse_raddr;
	wire [DW-1:0]   dct_inverse_rdata;
	// Write-only port
	wire [AW-1:0]   dct_inverse_waddr;
	wire [DW-1:0]   dct_inverse_wdata;
	wire 			dct_inverse_wr_enable;

	// **** signal for decompressor_top ****
	wire [2:0] sram_sel;
	
	reg [2:0] state;
	localparam 	STATE_SRAM_VGA = 0,
				STATE_CONVERSION = 1,
				STATE_UPSAMPLE = 2;
				STATE_DCT_INVERSE = 3;
				
	localparam 	SEL_SRAM_VGA = 0,
				SEL_CONVERSION = 1,
				SEL_UPSAMPLE = 2;
				SEl_DCT_INVERSE = 3;
				
	// ================================= Internal Logic =============================
	assign sram_sel = state;

	always@(posedge clk)begin
		if(reset)begin
			state <= STATE_DCT_INVERSE;
			sram_vga_start <= 0;
		end 
		else begin
			sram_vga_start <= 0;
			conversion_start <= 0;
			upsample_start <= 0;
			
			case(state)
				STATE_DCT_INVERSE:begin
					if(dct_inverse_done)begin
						state <= STATE_UPSAMPLE;
						upsample_start <= 1;
					end
				end
				STATE_UPSAMPLE:begin
					if(upsample_done)begin
						state <= STATE_CONVERSION;
						conversion_start <=1;
					end
				end
				STATE_CONVERSION:begin
					if(conversion_done)begin
						state <= STATE_SRAM_VGA;
						sram_vga_start <=1;
					end
				end
				STATE_SRAM_VGA:begin
					
				end
			endcase
		end
	end
	
	
	// **** This section code used for other phase of project ****
	// 
	// 
	// ***********************************************************
	
	// **** Mux for select module that granted for access to sram ****
	always@(*)begin
		case (sram_sel)
			SEL_SRAM_VGA: begin // sram_vga_controller
				sram_raddr		<= sram_vga_raddr		;
				sram_waddr		<= sram_vga_waddr   	;
				sram_wdata		<= sram_vga_wdata   	;
				sram_wr_enable	<= sram_vga_wr_enable	;
			end
			SEL_CONVERSION: begin // conversion
				sram_raddr		<= conversion_raddr	;
				sram_waddr		<= conversion_waddr   	;
				sram_wdata		<= conversion_wdata   	;
				sram_wr_enable	<= conversion_wr_enable;
			end
			SEL_UPSAMPLE: begin // upsampling
				sram_raddr		<= upsample_raddr	;
				sram_waddr		<= upsample_waddr   	;
				sram_wdata		<= upsample_wdata   	;
				sram_wr_enable	<= upsample_wr_enable;
			end
			SEl_DCT_INVERSE: begin //dct_inverse
				sram_raddr		<= dct_inverse_raddr	;
				sram_waddr		<= dct_inverse_waddr   	;
				sram_wdata		<= dct_inverse_wdata   	;
				sram_wr_enable	<= dct_inverse_wr_enable;
			end
			default:begin
				sram_raddr		<= 0;
				sram_waddr		<= 0;
				sram_wdata		<= 0;
				sram_wr_enable	<= 0;
			end
		endcase
	end
	
	// ====================== sram_rdata port connect to all module ===================
	assign sram_vga_rdata = sram_rdata;
	assign conversion_rdata = sram_rdata;
	assign upsample_rdata = sram_rdata;
	assign dct_inverse_rdata = sram_rdata;
	// Upsampling
	upsampling_top#(
		.WRITE_ADDR_BASE	(UPSAMPLE_WRITE_ADDR_BASE),
		.READ_ADDR_BASE		(UPSAMPLE_READ_ADDR_BASE),
		.W					(IMAGE_WIDTH),
		.H					(IMAGE_HEIGHT)
	)upsampling_top(
		.clk		(clk),
		.reset		(reset),
		
		.start		(upsample_start), // 
		.done		(upsample_done),
	// *********** SRAM Interface Signals ****************************
	// Read-only port
		.raddr		(upsample_raddr),
		.rdata		(upsample_rdata),
	// Write-only port
		.waddr		(upsample_waddr),
		.wdata		(upsample_wdata),
		.wr_enable	(upsample_wr_enable)
	);
	
	// Conversion YUV to RGB
	yuv_to_rgb_conversion#(
		.WRITE_ADDR_BASE	(CONVERSION_WRITE_ADDR_BASE),
		.READ_ADDR_BASE		(CONVERSION_READ_ADDR_BASE),
		.W					(IMAGE_WIDTH),
		.H					(IMAGE_HEIGHT)
	)yuv_to_rgb_conversion(
		.clk		(clk),
		.reset		(reset),
		
		.start		(conversion_start), // 
		.done		(conversion_done),
	// *********** SRAM Interface Signals ****************************
	// Read-only port
		.raddr		(conversion_raddr),
		.rdata		(conversion_rdata),
	// Write-only port
		.waddr		(conversion_waddr),
		.wdata		(conversion_wdata),
		.wr_enable	(conversion_wr_enable)
	);

	//sram_vga_controller#(
	sram_vga_controller#(
		.AW				(AW),
		.DW				(DW),
		.START_ADDR		(CONVERSION_WRITE_ADDR_BASE),
		.IMAGE_WIDTH	(IMAGE_WIDTH),
		.IMAGE_HEIGHT	(IMAGE_HEIGHT)
	)
	sram_vga_controller
	(
		.reset	(reset	),
		.clk	(clk	),
		
		.start	(sram_vga_start	),
		.done	(done	),
	// *********** SRAM Interface Signals ****************************
	// Read-only port
		.raddr		(sram_vga_raddr		),
		.rdata		(sram_vga_rdata		),
	// Write-only port
		.waddr		(sram_vga_waddr		),
		.wdata		(sram_vga_wdata		),
		.wr_enable	(sram_vga_wr_enable	),	
		
	// ************* VGA Controller Interface Signals *****************
		.vgastart	(vgastart	),
		.r			(r			),
		.g			(g			),
		.b			(b			)
	);
	
endmodule
