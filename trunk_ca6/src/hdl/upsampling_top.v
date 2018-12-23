// `default_nettype none
module upsampling_top#(
	parameter W = 320,
	parameter H = 240,
	parameter DW = 16,
	parameter AW = 18,
	parameter WRITE_ADDR_BASE = 115200,
	parameter READ_ADDR_BASE = 0)
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

wire clear;
wire cmp1, cmp2, cmp3, cmp4;
wire inc1, inc2, inc3;
wire enr1, enr2, enr3, enr4, enr5, enr6;
wire r1_5mux, r6mux;
wire wmux;
wire rset3;

upsampling_controller upsam_crtl
(
	.clk(clk),
	.start(start),
	.cmp1(cmp1),
	.cmp2(cmp2),
	.cmp3(cmp3),
	.cmp4(cmp4),
	.clear(clear),
	.rset3(rset3),
	.inc1(inc1),
	.inc2(inc2),
	.inc3(inc3),
	.enr1(enr1),
	.enr2(enr2),
	.enr3(enr3),
	.enr4(enr4),
	.enr5(enr5),
	.enr6(enr6),
	.r1_5mux(r1_5mux),
	.r6mux(r6mux),
	.wmux(wmux),
	.wren(wr_enable),
	.done(done),
	.reset(reset)
);

upsampling_datapath#(
	.H(H),
	.W(W),
	.DW(DW),
	.AW(AW),
	.READ_ADDR_BASE(READ_ADDR_BASE),
	.WRITE_ADDR_BASE(WRITE_ADDR_BASE)	
)upsam_dp
(
	.clk(clk),
	.clear(clear),
	.rset3(rset3),
	.rdata(rdata),
	.enr1(enr1),
	.enr2(enr2),
	.enr3(enr3),
	.enr4(enr4),
	.enr5(enr5),
	.enr6(enr6),
	.inc1(inc1),
	.inc2(inc2),
	.inc3(inc3),
	.r1_5mux(r1_5mux),
	.r6mux(r6mux),
	.wmux(wmux),
	.cmp1(cmp1),
	.cmp2(cmp2),
	.cmp3(cmp3),
	.cmp4(cmp4),
	.waddr(waddr),
	.wdata(wdata),
	.raddr(raddr)
);

endmodule

