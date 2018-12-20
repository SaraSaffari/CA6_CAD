module upsampling_datapath#(
	parameter W = 320,
	parameter H = 240,
	parameter DW = 16,
	parameter AW = 18,
	parameter WRITE_ADDR_BASE = 115200,
	parameter READ_ADDR_BASE = 0
)
(
	input wire clk,
	input wire clear,
	input wire rset3,
	input wire[DW - 1 :0] rdata,
	input wire enr1,
	input wire enr2,
	input wire enr3,
	input wire enr4,
	input wire enr5,
	input wire enr6,
	input wire inc1,
	input wire inc2,
	input wire inc3,
	input wire r1_5mux,
	input wire r6mux,
	input wire wmux,
	output wire cmp1,
	output wire cmp2,
	output wire cmp3,
	output wire cmp4,
	output wire[AW - 1 : 0] waddr,
	output wire[DW - 1 : 0] wdata,
	output wire[AW - 1 : 0] raddr
);
	
	reg[7:0] R1, R2, R3, R4, R5, R6;
	reg[16:0] cnt1, cnt2;
	reg[8:0] cnt3;
	
	wire[15:0] res;
	wire[7:0] inr1, inr2, inr3, inr4, inr5, inr6;
	wire[15:0] mr1, mr2, mr3, mr4, mr5,mr6;
	
	assign inr1 = r1_5mux ? R2 : rdata[7:0];
	assign inr2 = R3;
	assign inr3 = r1_5mux ? R4 : rdata[7:0];
	assign inr4 = r1_5mux ? R5 : rdata[15:8];
	assign inr5 = r1_5mux ? R6 : rdata[7:0];
	assign inr6 = r6mux ? rdata[7:0] : rdata[15:8];
	
	assign mr1 = R1 * 21;
	assign mr2 = R2 * -52;
	assign mr3 = R3 * 159;
	assign mr4 = R4 * 159;
	assign mr5 = R5 * -52;
	assign mr6 = R6 * 21;
	
	assign res = mr1 + mr2 + mr3 + mr4 + mr5 + mr6 + 128;
	
	assign wdata = wmux ? {res[15:8], R3} : rdata;
	
	// assign raddr = {1'b0, cnt1};
	// assign waddr = {1'b1, cnt2};

	assign waddr = WRITE_ADDR_BASE + cnt2;
	assign raddr = READ_ADDR_BASE + cnt1;
	
	assign cmp1 = (cnt2 == W * H / 2 - 1) ? 1'b1 : 1'b0;
	assign cmp2 = (cnt3 == W - 5) ? 1'b1 : 1'b0;
	assign cmp3 = (cnt3 == W - 1) ? 1'b1 : 1'b0;
	assign cmp4 = (cnt2 == W * H * 3 / 2 - 1) ? 1'b1 : 1'b0;
	
	always@(posedge clk) begin
		if(clear)begin
			cnt1 = 0;
			cnt2 = 0;
			cnt3 = 0;
		end
		
		if(rset3) cnt3 = 0;
		
		if(enr1) R1 = inr1;
		
		if(enr2) R2 = inr2;
		
		if(enr3) R3 = inr3;
		
		if(enr4) R4 = inr4;
		
		if(enr5) R5 = inr5;
		
		if(enr6) R6 = inr6;
		
		if(inc1) cnt1 = cnt1 + 1;
		
		if(inc2) cnt2 = cnt2 + 1;
		
		if(inc3) cnt3 = cnt3 + 1;	
	end
	
endmodule