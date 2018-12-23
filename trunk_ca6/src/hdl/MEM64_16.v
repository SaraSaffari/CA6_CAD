module MEM64_16#(
		parameter AW = 18,
		parameter DW = 16)
	(
		input wire clock,
		input wire start,
		input wire [AW-1:0] r_addr, 
		input reg [DW-1:0] r_data
	);

	reg reset;	
	reg ienb, jenb, sram_count_enb, mem64_enb;
	wire [2:0] icounter, jcounter;
	wire [AW-1:0] sram_counter;
	reg [DW-1:0][7:0][7:0] Mem64_16 ;
	
	counterr #(.size(3)) icount(
		.clk(clock),
		.reset(reset),
		.en(ienb),
		.counter(icounter)
	);

	counterr #(.size(3)) jcount(
		.clk(clock),
		.reset(reset),
		.en(jenb),
		.counter(jcounter)
	);

	counterr #(.size(AW)) sram_counter_module(
		.clk(clock),
		.reset(reset),
		.en(sram_count_enb),
		.counter(sram_counter)
	);

	always @(posedge clock) begin
		if (mem64_enb)
			Mem64_16[icounter][jcounter] <= r_data;
	end



// Controller:


parameter [1:0] IDLE = 2'd0, START = 2'd1, S1 = 2'd2, S2 = 2'd3;
reg [1:0] ps, ns = 2'd0;
reg done;

always @(ps) begin
	
	{ienb, jenb, sram_count_enb, done} = 20'd0;

	case(ps)
		IDLE: begin end
		START: begin end
		S1:	sram_count_enb = 1;
		S2: begin sram_count_enb = 1; mem64_enb = 1; jenb = 1; if (sram_counter[2:0] == 3'd0) ienb = 1'b1; end
	endcase
end

always @(ps) begin

	case(ps)
		IDLE: ns = START;
		START: if(start) ns = S1; else ns = START;
		S1:	ns = S2;
		S2:	if (sram_counter[5:0] == 6'd0) begin done = 1; ns = START; end else ns = S2;
	endcase
end

always @(posedge clock) begin
	ps <= ns;
end

endmodule


//# D:/CA_CA/CAD/CA6_CADSOL/trunk_ca6/sim
