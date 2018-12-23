module RAM(clock, Ri_address, Rj_address, W_data, Wi_address, Wj_address, Wen, R_data);
	input clock, Wen;
	input[2:0] Ri_address, Rj_address, Wi_address, Wj_address;
	input [15:0] W_data;
	output reg [15:0] R_data[7:0];

	reg[15:0] word[7:0][7:0]; 
	
	assign R_data = word[Ri_address];
	
	always @(clock)begin
		if (Wen)
			word[Wi_address][Wj_address] <= W_data;
	end
endmodule 
