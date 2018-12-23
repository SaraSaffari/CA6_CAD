module ROM(clock, Ri_address, Rj_address, R_data);
	input clock;
	input[2:0] Ri_address, Rj_address;
	output [15:0] R_data[7:0];

	reg[15:0] word[7:0][7:0]; 
	
	assign R_data = word[Ri_address];

endmodule 
