// `default_nettype none
module yuv_to_rgb_conversion#(
	parameter WRITE_ADDR_BASE = 115200,
	parameter READ_ADDR_BASE = 0,
	parameter W = 320,
	parameter H = 240,
	parameter DW = 16,
	parameter AW = 18)
(
	input wire clk,
	input wire reset,
	input wire start, // 
	output wire done,
	// *********** SRAM Interface Signals ****************************
	// Read-only port
	output wire [AW-1:0]	raddr,
	input wire	[DW-1:0]	rdata,
	// Write-only port
	output wire [AW-1:0]	waddr,
	output wire [DW-1:0]	wdata,
	output wire 			wr_enable
);
	
	wire cmp;
	wire clear;
	wire eny1, enu1, env1;
	wire eny2, enu2, env2;
	wire[1:0] smuxra;
	wire[1:0] smuxop1;
	wire smuxop2;
	wire smuxop3;
	wire inc1;
	wire inc2;
	
	
	// Add your code here ... .
yuv_to_rgb_controller yuv_ctlr
(
	.clk(clk		),
	.start(start	),
	.cmp(cmp		),
	.clear(clear	),
	.eny1(eny1		),
	.enu1(enu1		),
	.env1(env1		),
	.eny2(eny2		),
	.enu2(enu2		),
	.env2(env2		),
	.smuxra(smuxra	),
	.smuxop1(smuxop1),
	.smuxop2(smuxop2),
	.smuxop3(smuxop3),
	.inc1(inc1		),
	.inc2(inc2		),
	.wren(wr_enable	),
	.done(done		)
);

yuv_to_rgb_datapath #(
	.WRITE_ADDR_BASE(WRITE_ADDR_BASE),
	.READ_ADDR_BASE(READ_ADDR_BASE),
	.W(W),
	.H(H)
)
yuv_dp
(
	.clk(clk		),
	.clear(clear	),
	.rdata(rdata	),
	.eny1(eny1		),
	.enu1(enu1		),
	.env1(env1		),
	.eny2(eny2		),
	.enu2(enu2		),
	.env2(env2		),
	.smuxra(smuxra	),
	.smuxop1(smuxop1),
	.smuxop2(smuxop2),
	.smuxop3(smuxop3),
	.inc1(inc1		),
	.inc2(inc2		),
	.cmp(cmp		),
	.waddr(waddr	),
	.wdata(wdata	),
	.raddr(raddr	)
);
	
endmodule

