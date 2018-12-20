module sram_vga_controller#(
		parameter AW = 20,
		parameter DW = 16,
		parameter START_ADDR = 0,
		parameter IMAGE_WIDTH = 320,
		parameter IMAGE_HEIGHT = 240)
	(
		input wire reset,
		input wire clk,
		
		input wire start, // 
		output reg done,
		
		// *********** SRAM Interface Signals ****************************
		// Read-only port
		output wire [AW-1:0]	raddr,
		input wire	[DW-1:0]	rdata,
		// Write-only port
		output wire [AW-1:0]	waddr,
		output wire [DW-1:0]	wdata,
		output wire 			wr_enable,
		// ************* VGA Controller Interface Signals *****************
		output reg vgastart,
		output wire [7:0] r,
		output wire [7:0] g,
		output wire [7:0] b
	);	
	
	localparam W = IMAGE_WIDTH;
	localparam H = IMAGE_HEIGHT;
	
	assign waddr = 0;
	assign wdata = 0;
	assign wr_enable = 0;
	
	// Add your code here ... .
	reg [23:0] rgb;
	reg vga_start_int ;
	reg rd_ack;
	
	reg [15:0] rdata0, rdata1, rdata2;
	reg [2:0] sel_rgb, n_sel_rgb ;
	
	reg [31:0] cnt ;
	reg clear_cnt , en_cnt ;
	
	reg [2:0] state, nstate;
	localparam 	STATE_IDLE = 0,
				STATE_W = 1,
				STATE_H = 2,
				STATE_RGB1 = 3,
				STATE_RGB2 = 4,
				STATE_RGB3 = 5,
				STATE_RGB4 = 6;
	reg [2:0] en_rdata ;
	always@(posedge clk)begin
		// state register
		if(reset)
			state <=0;
		else
			state <= nstate;
		
		// cnt register
		if(reset || clear_cnt)
			cnt <= START_ADDR;
		else if (en_cnt)
			cnt <= cnt + 1 ;
		if(reset)
			sel_rgb<=0;
		else
			sel_rgb <= n_sel_rgb ;
		
		rd_ack <= en_cnt;
		if(rd_ack)begin
			case (en_rdata)
				1:
					rdata0 <= rdata;	
				2:
					rdata1 <= rdata;	
				4:
					rdata2 <= rdata;	
			endcase
			
		end
		// rgb mux and register
		case (n_sel_rgb)
			3'h0:
				rgb <= {8'h0,W[15:0]};
			3'h1:
				rgb <= {8'h0,H[15:0]};
			3'h2:
				rgb <= {rdata1[7:0],rdata0[15:0]};
			3'h3:
				rgb <= {rdata2[15:0],rdata1[15:8]};
			3'h4:
				rgb <= {rdata2[15:0],rdata1[15:8]};
			3'h5:
				rgb <= {rdata1[15:0],rdata0[15:8]};
		endcase
		
		vgastart <= vga_start_int;
	end
	assign r = rgb[0+:8];
	assign g = rgb[8+:8];
	assign b = rgb[16+:8];
	
	assign raddr = cnt[AW-1:0];
	always@(*)begin
		clear_cnt <=0;
		en_cnt <=0;
		
		done <= 0 ;
		en_rdata <=0;
		vga_start_int <= 0;
		
		nstate <= state;
		n_sel_rgb <= sel_rgb;
		
		case(state)
			STATE_IDLE:begin
				if(start)begin
					nstate <= STATE_W;
					en_cnt <=1;
					vga_start_int<=1;
					
				end
			end
			STATE_W :begin
				n_sel_rgb <= 0;
				nstate <= STATE_H;
				en_cnt <= 1;
				en_rdata <= 1;
			end
			STATE_H:begin
				n_sel_rgb <= 1;
				nstate <= STATE_RGB1;
				en_cnt <= 1;
				en_rdata <= 2;
			end
			STATE_RGB1:begin
				n_sel_rgb <= 2;
				nstate <= STATE_RGB2;
				en_rdata <= 4;
			end
			STATE_RGB2:begin
				n_sel_rgb <= 2;
				nstate <= STATE_RGB3;
				en_cnt <= 1;
			end
			STATE_RGB3:begin
				en_rdata <= 1;
				n_sel_rgb <= 3;
				nstate <= STATE_RGB4;
				en_cnt <= 1;
			end
			STATE_RGB4:begin
				en_rdata <= 2;
				n_sel_rgb <= 3;
				nstate <= STATE_RGB1;
				en_cnt <= 1;
				if(cnt == START_ADDR + W*H*3/2 + 2)begin
					nstate <= STATE_IDLE;
					done <= 1;
					clear_cnt <= 1;
				end
			end
			default:
				nstate <= STATE_IDLE;
		endcase
	end
	
endmodule
