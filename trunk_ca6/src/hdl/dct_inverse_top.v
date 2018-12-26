module dct_inverse_top#(
	parameter AW = 18,
	parameter DW = 16)
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
	wire part_3_done;
	wire part_3_start;
	wire [7:0] final_result;
	wire mem64_done;
	wire icdt_done;
	wire mem32_done;
	wire [2:0] i , j;
	wire [175:0] mem_out;
	wire Wen_32; 

	assign done = (waddr >= 115200 ? 1: 0);
 	MEM64_16#(
		.AW (18),
		.DW (16)
	)mem64(
		.clock(clk),
		.start(start || icdt_done),
		.r_data(rdata),
		.i_read(i),
		.j_read(),
		.mem_out(mem_out),
		.r_addr(raddr),
		.done(mem64_done)
	);


	iCDT idct(
		.clk(clk),
		.start(mem64_done),
		.out_mem64(mem_out),
		.out_i(i),
		.out_j(j),
		.final_result(final_result),
		.done(icdt_done),
		.Wen_32(Wen_32),
		.part_3_start(part_3_start)
	);


	MEM32_16#(
		.AW (18),
		.DW (16)
	)mem32(
		.clock(clk),
		.start(part_3_start),
		.mem32_enb (Wen_32),
		.r_data(final_result),
		.w_data(wdata),
		.in_icounter(i),
		.in_jcounter(j),
		.final_addr(waddr),
		.done(part_3_done)
	);



endmodule