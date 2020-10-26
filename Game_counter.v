//This module is used for sending the pulse signal each half second 
module GameCounter(clk, pulse, Enable);
	input clk;
	output reg pulse;	
	input Enable;
	
	reg [26:0]counter;

	always @(posedge clk)
	begin
		if (!Enable) 
			begin
				counter <= 26'b0;
				
			end 
			
		else if(Enable)
		begin
			if (counter == 25'd24999999)
			begin
				counter <= 26'b0;
				pulse <= ~pulse;
			end 
			else 
			begin
				counter <= counter + 1'b1;
			end
		end
	end	
endmodule