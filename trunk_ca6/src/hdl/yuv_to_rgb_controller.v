`default_nettype none
module yuv_to_rgb_controller
(
	input wire clk,
	input wire start,
	input wire cmp,
	output wire clear,
	output wire eny1,
	output wire enu1,
	output wire env1,
	output wire eny2,
	output wire enu2,
	output wire	env2,
	output wire[1:0] smuxra,
	output wire[1:0] smuxop1,
	output wire smuxop2,
	output wire smuxop3,
	output wire inc1,
	output wire inc2,
	output wire wren,
	output wire done
);

	reg [3:0]state = 4'b0000;
	always @(posedge clk) begin
		if (start)
			state = 4'b0000;
		else if (state == 4'b1000)
			state = cmp ? 4'b1001 : 4'b0011;
		else if (state == 4'b1001)
			state = 4'b0000;
		else
			state = state + 1;
	end
	
	assign clear = (state == 4'b0000) ? 1'b1 : 1'b0;
	assign eny1 = (state == 4'b0001 || state == 4'b0111) ? 1'b1 : 1'b0;
	assign enu1 = (state == 4'b0010 || state == 4'b1000) ? 1'b1 : 1'b0;
	assign env1 = (state == 4'b0011) ? 1'b1 : 1'b0;
	assign eny2 = (state == 4'b0100) ? 1'b1 : 1'b0;
	assign enu2 = (state == 4'b0101) ? 1'b1 : 1'b0;
	assign env2 = (state == 4'b0110) ? 1'b1 : 1'b0;
	assign smuxra = (state == 4'b0000 || state == 4'b0011 || state == 4'b0110) ? 2'b00 :
					(state == 4'b0001 || state == 4'b0100 || state == 4'b0111) ? 2'b01 :
					(state == 4'b0010 || state == 4'b0101 || state == 4'b1000) ? 2'b10 : 2'bxx;
	assign smuxop1 = (state == 4'b0011 || state == 4'b0110) ? 2'b00 :
					 (state == 4'b0100 || state == 4'b0111) ? 2'b01 :
					 (state == 4'b0101 || state == 4'b1000) ? 2'b10 : 2'bxx;
	assign smuxop2 = (state == 4'b0011 || state == 4'b0100 || state == 4'b0101) ? 1'b0 :
					 (state == 4'b0110 || state == 4'b0111 || state == 4'b1000) ? 1'b1 : 1'bx;
	assign smuxop3 = (state == 4'b0011 || state == 4'b0110) ? 1'b0 :
					 (state == 4'b0100 || state == 4'b0101 || state == 4'b0111 || state == 4'b1000) ? 1'b1 : 1'bx;
	assign inc1 = (state == 4'b0101) ? 1'b1 : 1'b0;
	assign inc2 = (state == 4'b0100 || state == 4'b0110 || state == 4'b1000) ? 1'b1 : 1'b0;
	assign wren = (state == 4'b0100 || state == 4'b0110 || state == 4'b1000) ? 1'b1 : 1'b0;
	assign done = (state == 4'b1001) ? 1'b1 : 1'b0;
	
endmodule
