module dct_inverse_top#(
	)
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

	wire mem64_done;
	wire icdt_done;
	wire mem32_done;


 	MEM64_16#(
		.AW (18),
		.DW (16)
	)mem64(
		.clock(clk),
		.start(start),
		.r_data(),
		.i_read(),
		.j_read(),
		.mem_out(),
		.r_addr(),
		.done(mem64_done)
	);


	iCDT i(
		.clk(clk),
		.start(mem64_done),
		.out_mem64(),
		.out_i(),
		.out_j(),
		.final_result(),
		.done(icdt_done),
		.Wen_32()
	);


	MEM32_16#(
		.AW (18),
		.DW (16)
	)mem32(
		.clock(clk),
		.start(icdt_done),
		.r_data()
		.done(done)
	);