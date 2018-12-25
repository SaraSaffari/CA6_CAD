module MEM32_16#(
		parameter AW = 18,
		parameter DW = 16)
	(
		input wire clock,
		input wire start,
		// input wire [AW-1:0] r_addr, // why isn't it used????
		input reg [DW-1:0] r_data
	);

	reg reset;	
	reg ienb, jenb, mem32_enb;
	 // sram_count_enb, 
	wire [2:0] icounter, jcounter;
	// wire [AW-1:0] sram_counter;
	reg [DW-1:0][7:0][7:0] Mem32_16 ;
	
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


	// counterr #(.size(AW)) sram_counter_module(
	// 	.clk(clock),
	// 	.reset(reset),
	// 	.en(sram_count_enb),
	// 	.counter(sram_counter)
	// );

	always @(posedge clock) begin
		if (mem32_enb)
		begin
			r_data = r_data >>> 8;
			if (r_data < 8'b 0)
				r_data = 8'b 0;
			if (r_data > 8'd 255)
				r_data = 8'd 255;
			Mem32_16[icounter][jcounter] = r_data;
		end
	end



// Controller:


parameter [1:0] IDLE = 2'd0, START = 2'd1, S1 = 2'd2, S2 = 2'd3;
reg [1:0] ps, ns = 2'd0;
reg done, start_part2, Wen_SRAM;

always @(ps) begin
	
	{ienb, jenb, done, start_part2, Wen_SRAM} = 20'd0;

	case(ps)
		IDLE :reset = 1'b1;
		START:begin end
		S1   :begin jenb = 1'b1; if(icount == 3'd7) ienb = 1'b1; end
		S2   :Wen_SRAM = 1'b1;
	endcase
end

always @(ps) begin

	case(ps)
		IDLE :ns = START;
		START:if(start) ns = S1; 
			  else ns = START;
		S1   :ns = S2;
		S2   :if (icount != 7 || jcount != 7) ns = S1;
			  else begin ns = START; done = 1'b1; start_part2 = 1'b1; end
	endcase
end

always @(posedge clock) begin
	ps <= ns;
end

endmodule


