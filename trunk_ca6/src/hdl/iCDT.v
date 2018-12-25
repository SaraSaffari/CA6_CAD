module iCDT(
	clk, start, out_mem64, out_i, out_j);

	input wire clk, start;
	reg en_i, en_j, Wen_temp, Smux1, Smux2, rst;
	input wire [15:0] out_mem64;

	output reg [2:0] out_i, out_j;

	wire[63:0] out_temp, outMux1, outMux2, out_C, out_C_prime, result;
	wire[7:0] resMult0, resMult1, resMult2, resMult3, resMult4, resMult5, resMult6, resMult7;

	counterr cnt_i (
		.clk(clk),
		.reset(rst),
		.en(en_i),
		.counter(out_i));

	counterr cnt_j (
		.clk(clk),
		.reset(rst),
		.en(en_j),
		.counter(out_j));

	mux_2_input #(.WORD_LENGTH (16)) mux1(
		.in1(out_mem64),   
		.in2(out_temp),
		.sel(Smux1),
		.out(outMux1));

	mux_2_input #(.WORD_LENGTH (16)) mux2(
		.in1(out_C),   
		.in2(out_C_prime),
		.sel(Smux2),
		.out(outMux2));

	RAM temp(
		.clock(clk), 
		.Ri_address(out_i), 
		.Rj_address(out_j), 
		.W_data(result), 
		.Wi_address(out_i), 
		.Wj_address(out_j), 
		.Wen(Wen_temp), 
		.R_data(out_temp));

	ROM C(
		.clock(clk), 
		.Ri_address(out_i), 
		.Rj_address(out_j),
		.R_data(out_C));

	POM C_prime(
		.clock(clk), 
		.Ri_address(out_i), 
		.Rj_address(out_j),
		.R_data(out_C_prime));

	assign resMult0 = outMux1[7 :0 ] * outMux2[7 :0 ];
	assign resMult1 = outMux1[15:8 ] * outMux2[15:8 ];
	assign resMult2 = outMux1[23:16] * outMux2[23:16];
	assign resMult3 = outMux1[31:24] * outMux2[31:24];
	assign resMult4 = outMux1[39:32] * outMux2[39:32];
	assign resMult5 = outMux1[47:39] * outMux2[47:39];
	assign resMult6 = outMux1[55:48] * outMux2[55:48];
	assign resMult7 = outMux1[63:56] * outMux2[63:56];

	assign result = resMult7+ resMult6+ resMult5+ resMult4+ resMult3+ resMult2+ resMult1+ resMult0;



//controller 
	parameter [1:0] IDLE = 2'd0, START = 2'd1, S1 = 2'd2, S2 = 2'd3;
	reg [1:0] ps, ns = 2'd0;
	reg Wen_32, done, start_p1, start_p3;

	always @(ps) begin
		
		{Smux1, Smux2, en_i, en_j, Wen_temp, Wen_32} = 10'd0;

		case(ps)
			IDLE: rst = 1'b1;
			START: begin end
			S1:	begin Smux1 = 1'b0; Smux2 = 1'b0; en_j = 1'b1;  
				if(out_j == 3'd7) en_i = 1'b1;
				Wen_temp = 1'b1;
			end
			S2: begin Smux1 = 1'b1; Smux2 = 1'b1; en_j = 1'b1; 
				if(out_j == 3'd7) en_i = 1'b1; 
				Wen_32 = 1'b1;
			end
		endcase
	end

	always @(ps) begin

		case(ps)
			IDLE :ns = START;
			START:if(start) ns = S1; 
				  else ns = START;
			S1   :if(out_i != 3'd7 || out_j != 3'd7) ns = S1; 
				  else ns = S2;
			S2   :if(out_i != 3'd7 || out_j != 3'd7) ns = S2; 
				  else begin done = 1; start_p1 = 1'b1; start_p3 = 1'b1; ns = START; end
		endcase
	end

	always @(posedge clk) begin
		ps <= ns;
	end

endmodule