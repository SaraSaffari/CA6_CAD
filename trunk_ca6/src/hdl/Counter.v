module counterr(clk, reset, en, counter);
reg [2:0] counter_up;
output[7:0] counter;
input reset, en, clk;
// up counter
always @(posedge clk)
	begin
		if(reset)
			counter_up <= 7'd0;
		else 
			if (en)
		 		counter_up <= counter_up + 7'd1;
	end 
assign counter = counter_up;
endmodule