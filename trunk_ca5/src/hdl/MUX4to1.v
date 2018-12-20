module mux_4_input #(parameter integer WORD_LENGTH = 24) (in1, in2, in3, in4, sel, out);
	input [1:0]sel;
	input[WORD_LENGTH-1:0] in1, in2, in3,in4;
	output reg [WORD_LENGTH-1:0] out;
	always @(*) begin
		case(sel)
		2'b00: out <= in1;
		2'b01: out <= in2;
		2'b10: out <= in3;
		2'b11: out <= in4;
		default: out <= out;
		endcase
	end
endmodule