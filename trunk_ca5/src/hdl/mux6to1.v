module mux_6_input #(parameter integer WORD_LENGTH = 16) (in1, in2, in3, in4, in5, in6, sel, out);
	input [2:0] sel;
	input[WORD_LENGTH-1:0] in1, in2, in3, in4, in5, in6;
	output reg [WORD_LENGTH-1:0] out;
	always @(sel) begin
		case(sel)
		3'b000: out <= in1;
		3'b001: out <= in2;
		3'b010: out <= in3;
		3'b011: out <= in4;
		3'b100: out <= in5;
		3'b101: out <= in6;
		default:out <= 16'b0000000000000000;
		endcase 	
	end
endmodule
