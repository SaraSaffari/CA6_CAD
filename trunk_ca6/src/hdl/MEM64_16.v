module MEM64_16#(
		parameter AW = 18,
		parameter DW = 16)
	(
		input wire clock,
		input wire start,
		input reg [DW-1:0] r_data,
		input wire [2:0] i_read,
		input wire [2:0] j_read,
		output wire [175:0] mem_out,
		output wire [AW-1:0] r_addr,
		output reg done
	);

	reg reset;	
	reg ienb, jenb, sram_count_enb, mem64_enb;
	wire [2:0] icounter, jcounter;
	reg [DW-1:0] Mem64_16 [0:63];
	
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

	counterr #(.size(AW)) r_addr_module(
		.clk(clock),
		.reset(reset),
		.en(sram_count_enb),
		.counter(r_addr)
	);

	always @(posedge clock) begin
		if (mem64_enb)
			Mem64_16[icounter << 3 + jcounter] <= r_data;
	end

	assign mem_out = {{{6 { Mem64_16[i_read << 3][15]}} , Mem64_16[i_read << 3]}, {{6 {Mem64_16[i_read << 3 + 1][15]}} , Mem64_16[i_read << 3 + 1]}, 
						{{6 { Mem64_16[i_read << 3 + 2][15]}}, Mem64_16[i_read << 3 + 2]}, {{6 { Mem64_16[i_read << 3 + 3][15]}}, Mem64_16[i_read << 3 + 3]}, 
						{{6 { Mem64_16[i_read << 3 + 4][15]}}, Mem64_16[i_read << 3 + 4]}, {{6 { Mem64_16[i_read << 3 + 5][15]}}, Mem64_16[i_read << 3 + 5]}, 
						{{6 { Mem64_16[i_read << 3 + 6][15]}}, Mem64_16[i_read << 3 + 6]}, {{6 { Mem64_16[i_read << 3 + 7][15]}}, Mem64_16[i_read << 3 + 7]} };

// Controller:


parameter [1:0] IDLE = 2'd0, START = 2'd1, S1 = 2'd2, S2 = 2'd3;
reg [1:0] ps, ns = 2'd0;

always @(ps) begin
	
	{ienb, jenb, sram_count_enb, done} = 20'd0;

	case(ps)
		IDLE: reset = 1'b1;
		START: begin end
		S1:	sram_count_enb = 1'b1;
		S2: begin sram_count_enb = 1'b1; mem64_enb = 1'b1; jenb = 1'b1; if (r_addr[2:0] == 3'd0) ienb = 1'b1; end
	endcase
end

always @(ps) begin

	case(ps)
		IDLE :ns = START;
		START:if(start) ns = S1; 
			  else ns = START;
		S1   :ns = S2;
		S2   :if (r_addr[5:0] == 6'd0) begin done = 1'b1; ns = START; end 
			  else ns = S2;
	endcase
end

always @(posedge clock) begin
	ps <= ns;
end

endmodule


//# D:/CA_CA/CAD/CA6_CADSOL/trunk_ca6/sim
