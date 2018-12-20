module counterr(clk, reset, en, counter);
reg [17:0] counter_up;
output[17:0] counter;
input reset, en, clk;
// up counter
always @(posedge clk)
	begin
		if(reset)
			counter_up <= 18'd0;
		else 
			if (en)
		 		counter_up <= counter_up + 18'd1;
	end 
assign counter = counter_up;
endmodule