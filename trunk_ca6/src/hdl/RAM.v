module RAM#(SIZE = 16) (clock, Rj_address, W_data, Wi_address, Wj_address, Wen, R_data);
	input clock, Wen;
	input[2:0] Rj_address, Wi_address, Wj_address;
	input [SIZE-1:0] W_data;
	output reg [15:0] R_data[7:0];

	reg [SIZE-1:0] word[0:63]; 
	
	assign R_data = { word[Rj_address], word[Rj_address + 8], word[Rj_address + 16], word[Rj_address + 24], word[Rj_address + 32], word[Rj_address + 40], word[Rj_address + 48], word[Rj_address + 56] };
	
	always @(clock)begin
		if (Wen)
			word[(Wi_address << 3) + Wj_address] <= W_data;
	end
endmodule 
