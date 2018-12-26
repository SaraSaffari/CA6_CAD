module MEM32_16#(
		parameter AW = 18,
		parameter DW = 16)
	(
		input wire clock,
		input wire start,
		// input wire [AW-1:0] r_addr, // why isn't it used????
		input reg mem32_enb,
		input reg [7:0] r_data,
		output wire [15:0] w_data,
		input wire [2:0] in_icounter, in_jcounter,
		output wire [AW-1:0] final_addr,
		output reg done
	);
	wire [2:0] icounter;
	wire [1:0] jcounter;
	reg reset;	
	reg ienb, jenb;
	reg [7:0] Mem32_16 [63:0];
	
	counterr #(.size(3)) icount(
		.clk(clock),
		.reset(reset),
		.en(ienb),
		.counter(icounter)
	);

	counterr #(.size(2)) jcount(
		.clk(clock),
		.reset(reset),
		.en(jenb),
		.counter(jcounter)
	);

	always @(posedge clock) begin
		if (mem32_enb)
		begin
			Mem32_16[in_icounter << 3 + in_jcounter] = r_data;
		end
	end

	assign w_data = {Mem32_16[icounter << 3 + jcounter << 1], Mem32_16[icounter << 3 + jcounter << 1 + 1]};

// Controller:


parameter [1:0] IDLE = 2'd0, START = 2'd1, S1 = 2'd2, S2 = 2'd3;
reg [1:0] ps, ns = 2'd0;
reg start_part2, Wen_SRAM;

always @(ps) begin
	
	{ienb, jenb, done, start_part2, Wen_SRAM} = 20'd0;

	case(ps)
		IDLE :reset = 1'b1;
		START:begin end
		S1   :begin jenb = 1'b1; if(jcounter == 3'd3) ienb = 1'b1; end
		S2   :begin Wen_SRAM = 1'b1; end 
	endcase
end

always @(ps) begin

	case(ps)
		IDLE :ns = START;
		START:if(start) ns = S1; 
			  else ns = START;
		S1   :ns = S2;
		S2   :if (icounter != 3'd7 || jcounter != 3'd7) ns = S1;
			  else begin ns = START; done = 1'b1; start_part2 = 1'b1; end
	endcase
end

always @(posedge clock) begin
	ps <= ns;
end

endmodule


