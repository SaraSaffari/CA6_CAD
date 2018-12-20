module upsampling_controller
(
	input wire clk,
	input wire start,
	input wire cmp1,
	input wire cmp2,
	input wire cmp3,
	input wire cmp4,
	input wire reset,
	output wire clear,
	output wire rset3,
	output wire inc1,
	output wire inc2,
	output wire inc3,
	output wire enr1,
	output wire enr2,
	output wire enr3,
	output wire enr4,
	output wire enr5,
	output wire	enr6,
	output wire r1_5mux,
	output wire r6mux,
	output wire wmux,
	output wire wren,
	output wire done
);
	reg [3:0]state = 4'd0;
	always @(posedge clk) begin
		if(reset) state = 4'd0;
		else begin
			if (state == 4'd0)
				state = start ? 4'd1 : 4'd0;
			else if (state == 4'd2)
				state = cmp1 ? 4'd3 : 4'd2;
			else if (state == 4'd6)
				state = cmp2 ? 4'd7 : 4'd5;
			else if (state == 4'd7)
				state = cmp3 ? (cmp4 ? 4'd9 : 4'd8) : 4'd7;
			else if (state == 4'd8)
				state = 4'd3;
			else if (state == 4'd9)
				state = 4'd0;
			else
				state = state + 1;	
		end
	end
	
	assign clear = (state == 4'd0);
	
	assign rset3 = (state == 4'd8);
	
	assign inc1 = (state == 4'd1 || state  == 4'd2 || state == 4'd3 || state == 4'd5 || state == 4'd8);
	assign inc2 = (state == 4'd2 || state  == 4'd5 || state == 4'd6 || state == 4'd7);
	assign inc3 = (state == 4'd5 || state  == 4'd6 || state == 4'd7);
	
	assign enr1 = (state == 4'd3 || state == 4'd5 || state == 4'd6 || state == 4'd7);
	assign enr2 = (state == 4'd4 || state == 4'd5 || state == 4'd6 || state == 4'd7);
	assign enr3 = (state == 4'd3 || state == 4'd5 || state == 4'd6 || state == 4'd7);
	assign enr4 = (state == 4'd3 || state == 4'd5 || state == 4'd6 || state == 4'd7);
	assign enr5 = (state == 4'd4 || state == 4'd5 || state == 4'd6 || state == 4'd7);
	assign enr6 = (state == 4'd4 || state == 4'd5 || state == 4'd6);
	
	assign r1_5mux = (state == 4'd5 || state == 4'd6 || state == 4'd7);
	assign r6mux = (state == 4'd5);
	
	assign wmux = (state == 4'd5 || state == 4'd6 || state == 4'd7);
	
	assign wren = (state == 4'd2 || state == 4'd5 || state == 4'd6 || state == 4'd7);
	
	assign done = (state ==	4'd9);
	
endmodule