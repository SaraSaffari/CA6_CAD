module mux_2_input #(parameter integer WORD_LENGTH = 16) (in1, in2, sel, out);
	input sel;
	input[WORD_LENGTH-1:0] in1, in2;
	output reg [WORD_LENGTH-1:0] out;
	always @(sel, in1, in2) begin
		if (sel)
			out <= in2;
		else
			out <= in1;
	end
endmodule
