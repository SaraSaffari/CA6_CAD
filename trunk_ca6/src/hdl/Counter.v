module counterr #(parameter integer size = 18)(clk, reset, en, counter);
reg [size-1:0] counter_up;
output[size-1:0] counter;

input reset, en, clk;
// up counter
always @(posedge clk)
	begin
		if(reset)
			counter_up <= {size{1'b0}};
		else 
			if (en)
		 		counter_up <= counter_up + {{(size-1){1'b0}}, 1'b1};
	end 
assign counter = counter_up;
endmodule