module cprimeROM(clock, Ri_address, R_data);
	parameter ROW_SIZE = 64;

	input clock;
	input[2:0] Ri_address;
	output [103:0] R_data;

	reg signed [12:0] WORD[0:ROW_SIZE-1]; 
	initial begin 
			WORD[0]	= 1448;
			WORD[1] = 2008;
			WORD[2] = 1892;
			WORD[3] = 1702;
			WORD[4] = 1448;
			WORD[5] = 1137;
			WORD[6] = 783;
			WORD[7] = 399;
			WORD[8]	= 1448;
			WORD[9] = 1702;
			WORD[10] = 783;
			WORD[11] = -400;
			WORD[12] = -1449;
			WORD[13] = -2009;
			WORD[14] = -1893;
			WORD[15] = -1138;
			WORD[16] = 1448;
			WORD[17] = 1137;
			WORD[18] = -784;
			WORD[19] = -2009;
			WORD[20] = -1449;
			WORD[21] = 399;
			WORD[22] = 1892;
			WORD[23] = 1702;
			WORD[24] = 1448;
			WORD[25] = 399;
			WORD[26] = -1893;
			WORD[27] = -1138;
			WORD[28] = 1448;
			WORD[29] = 1702;
			WORD[30] = -784;
			WORD[31] = -2009;
			WORD[32] = 1448;
			WORD[33] = -400;
			WORD[34] = -1893;
			WORD[35] = 1137;
			WORD[36] = 1448;
			WORD[37] = -1703;
			WORD[38] = -784;
			WORD[39] = 2008;
			WORD[40] = 1448;
			WORD[41] = -1138;
			WORD[42] = -784;
			WORD[43] = 2008;
			WORD[44] = -1449;
			WORD[45] = -400;
			WORD[46] = 1892;
			WORD[47] = -1703;
			WORD[48] = 1448;
			WORD[49] = -1703;
			WORD[50] = 783;
			WORD[51] = 399;
			WORD[52] = -1449;
			WORD[53] = 2008;
			WORD[54] = -1893;
			WORD[55] = 1137;
			WORD[56] = 1448;
			WORD[57] = -2009;
			WORD[58] = 1892;
			WORD[59] = -1703;
			WORD[60] = 1448;
			WORD[61] = -1138;
			WORD[62] = 783;
			WORD[63] = -400;

	end
	assign R_data = {WORD[Ri_address], WORD[Ri_address + 8], WORD[Ri_address + 16], WORD[Ri_address + 24], WORD[Ri_address + 32], WORD[Ri_address + 40], WORD[Ri_address + 48], WORD[Ri_address + 56]};

endmodule 
