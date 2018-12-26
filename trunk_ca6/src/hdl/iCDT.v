module iCDT(
	clk, start, out_mem64, out_i, out_j, final_result, done, Wen_32);

	input wire clk, start;
	reg en_i, en_j, Wen_temp, Smux1, Smux2, rst;
	input wire [175:0] out_mem64;

	output reg [2:0] out_i, out_j;
	output reg Wen_32;
	wire[127:0] outMux1;
	wire [103:0] out_C, out_C_prime, outMux2;
	output wire signed[21:0] result;
	output wire signed[7:0] final_result;
	output wire signed[21:0] f_result;
	wire signed[7:0] resMult0, resMult1, resMult2, resMult3, resMult4, resMult5, resMult6, resMult7;

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

	mux_2_input #(.WORD_LENGTH (176)) mux1(
		.in1(out_mem64),   
		.in2(out_temp),
		.sel(Smux1),
		.out(outMux1));

	mux_2_input #(.WORD_LENGTH (104)) mux2(
		.in1(out_C),   
		.in2(out_C_prime),
		.sel(Smux2),
		.out(outMux2));

	RAM #(.SIZE(22)) temp(
		.clock(clk), 
		.Rj_address(out_j), 
		.W_data(result), 
		.Wi_address(out_i), 
		.Wj_address(out_j), 
		.Wen(Wen_temp), 
		.R_data(out_temp));

	cROM C(
		.clock(clk), 
		.Rj_address(out_j),
		.R_data(out_C));

	cprimeROM C_prime(
		.clock(clk), 
		.Ri_address(out_i), 
		.R_data(out_C_prime));

	
	assign resMult0 = outMux1[21 :0] * outMux2[12 :0];
	assign resMult1 = outMux1[43:22] * outMux2[25:13];
	assign resMult2 = outMux1[65:44] * outMux2[38:26];
	assign resMult3 = outMux1[87:66] * outMux2[51:39];
	assign resMult4 = outMux1[109:88] * outMux2[64:52];
	assign resMult5 = outMux1[131:110] * outMux2[77:65];
	assign resMult6 = outMux1[153:132] * outMux2[90:78];
	assign resMult7 = outMux1[176:154] * outMux2[103:91];

	assign result = {(resMult7 + resMult6 + resMult5 + resMult4 + resMult3 + resMult2 + resMult1 + resMult0) >>> 8}[21:0];
	assign f_result = {(resMult7 + resMult6 + resMult5 + resMult4 + resMult3 + resMult2 + resMult1 + resMult0) >>> 16}[21:0];
	assign final_result = f_result > 255 ? 255 : f_result < 0 ? 0 : f_result;
//controller 
	parameter [1:0] IDLE = 2'd0, START = 2'd1, S1 = 2'd2, S2 = 2'd3;
	reg [1:0] ps, ns = 2'd0;
	reg start_p1, start_p3;
	output reg done;

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