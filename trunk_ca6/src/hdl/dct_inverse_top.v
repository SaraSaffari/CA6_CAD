module dct_inverse_top#(
	)
	(
		input wire clock;
		input wire start;
		output wire done;
	);

	wire mem64_done;
	wire icdt_done;
	wire mem32_done;

 	MEM64_16#(
		.AW (18),
		.DW (16)
	)mem64(
		.clock(clock),
		.start(start),
		.r_data(),
		.done(mem64_done)
	);


	iCDT i(
		.clk(clock),
		.start(mem64_done),
		.out_mem64(),
		.out_i(),
		.out_j(),
		.result(),
		.done(icdt_done)
	);


	MEM32_16#(
		.AW (18),
		.DW (16)
	)mem32(
		.clock(clock),
		.start(icdt_done),
		.r_data()
		.done(done)
	);