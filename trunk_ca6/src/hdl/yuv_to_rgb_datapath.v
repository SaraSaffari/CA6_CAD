`default_nettype none

module yuv_to_rgb_datapath#(
	parameter WRITE_ADDR_BASE = 115200,
	parameter READ_ADDR_BASE = 0,
	parameter W = 320,
	parameter H = 240
)
(
	input wire clk,
	input wire clear,
	input wire[15:0] rdata,
	input wire eny1,
	input wire enu1,
	input wire env1,
	input wire eny2,
	input wire enu2,
	input wire env2,
	input wire[1:0] smuxra,
	input wire[1:0] smuxop1,
	input wire smuxop2,
	input wire smuxop3,
	input wire inc1,
	input wire inc2,
	output wire cmp,
	output wire[17:0] waddr,
	output wire[15:0] wdata,
	output wire[17:0] raddr
);

	reg[7:0] y1, u1, v1;
	reg[7:0] y2, u2, v2;
	reg[7:0] dummy;
	wire[7:0] res;
	reg[17:0] cnt1 = 0;
	reg[17:0] cnt2 = 0;
	wire[17:0] offset ;
	
	wire[7:0] sv1;
	wire[7:0] sv2;
	
	wire signed[8:0] yout;
	wire signed[8:0] uout;
	wire signed[8:0] vout;
	
	wire signed[9:0] outsy;
	wire signed[9:0] outsu;
	wire signed[9:0] outsv;
	
	wire signed[25:0] outmy;
	wire signed[18:0] outmu1;
	wire signed[25:0] outmu;
	wire signed[17:0] outmv1;
	wire signed[25:0] outmv;
	wire signed[25:0] fsum;
	
	
	always @(posedge clk) begin
		if (clear) begin
			cnt1 = READ_ADDR_BASE;
			cnt2 = WRITE_ADDR_BASE;
		end
		if (eny1 == 1'b1) 
			y1 = rdata[7:0];
		if (enu1 == 1'b1)
			u1 = rdata[7:0];
		if (env1 == 1'b1)
			v1 = rdata[7:0];
		if (eny2 == 1'b1)
			y2 = rdata[15:8];
		if (enu2 == 1'b1)
			u2 = rdata[15:8];
		if (env2 == 1'b1)
			v2 = rdata[15:8];
			
		if (inc1)
			cnt1 = cnt1 + 1;
			
		if (inc2)
			cnt2 = cnt2 + 1;
		
		dummy = res;
	end
	
	assign offset = (smuxra == 2'b00) ? 0 :
			       (smuxra == 2'b01) ? W*H/2 : W*H; // Add 38400 and 76800
	assign raddr = cnt1 + offset;
	
	assign waddr = cnt2;
	
	assign cmp = (cnt2 == (WRITE_ADDR_BASE + W*H*3/2 -1)) ? 1'b1 : 1'b0;
	
	
	
	assign sv1 = (smuxop3 == 1'b1) ? v1 : rdata[7:0];
	assign sv2 = (smuxop3 == 1'b1) ? v2 : rdata[15:8];
	
	assign yout = (smuxop2 == 1'b1) ? y2 : y1;
	assign uout = (smuxop2 == 1'b1) ? u2 : u1;
	assign vout = (smuxop2 == 1'b1) ? sv2 : sv1;
	
	assign outsy = yout - 16;
	assign outsu = uout - 128;
	assign outsv = vout - 128;
	
	assign outmy = outsy * 76284;
	assign outmu1 = (smuxop1 == 2'b00) ? 0 :
				   (smuxop1 == 2'b01) ?  -25624 :
				   (smuxop1 == 2'b10) ? 132251 : 30'bx;

	assign outmu = (outsu) * outmu1;

	assign outmv1 = (smuxop1 == 2'b00) ? 104595 :
				   (smuxop1 == 2'b01) ? -53281 :
				   (smuxop1 == 2'b10) ? 0 : 30'bx;
	
	assign outmv = outsv * outmv1;
	assign fsum = outmy + outmu + outmv;
	assign res = (fsum < 0		 ) ? 8'b00000000 :
				 (fsum > 16777215) ? 8'b11111111 : fsum[23:16];
	
	assign wdata = {res, dummy};
	
	
	
endmodule
	
	
	
	
				   
				   
				   
				   
				   
	