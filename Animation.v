//This module is used for sending the pulse signal to the Animation module
//in order to tell the Animation module when to change the top left corner coordinate of the 
//draw shape
module Animation_Signal(clk, pulse, Enable);//SW[0] Enable
	input clk;
	output reg pulse;	
	input Enable;
	
	reg [23:0]counter;
	
	always @(posedge clk)
	begin
		if (!Enable) 
			begin
				counter <= 19'b0;
				
			end 
			
		else if(Enable)
		begin
			if (counter == 19'd418000)
											  
			begin
				counter <= 19'b0;
				pulse <= ~pulse;
			end 				
			else 
			begin
				counter <= counter + 1'b1;
			end
		end
	end	
endmodule

//This module is used for selecting the mode of shapes' movement
//and sending the new coordinate of the top left corner of the shape

module Animation(pulse, Enable, Up_Down, X_pos, Y_pos, Ctrl_Sig);//SW[0] Enable SW[1] Up_Down
	input pulse;
	input Enable;
	input Up_Down;
	output reg [7:0]X_pos;
	output reg [6:0]Y_pos;
	output reg [1:0] Ctrl_Sig;
	
	always@(posedge pulse)
	begin
		if(Ctrl_Sig > 2'b11)//reset to zero
		begin
			Ctrl_Sig <= 2'b0;
		end
		
		if(!Enable)  
		begin
				Y_pos <= Y_pos;
		end 
		
		else //Enable
		begin
			if(!Up_Down)// SW[1] = 0
			begin
				if(Y_pos <= 7'd118)
				begin
					Y_pos <= Y_pos + 7'd1;						
				end
				else
				begin
					Ctrl_Sig <= Ctrl_Sig + 2'b1;
					if(X_pos >= 7'd70)
						X_pos <= 7'd10;
					else
						X_pos <= X_pos + 7'd20;
					
					Y_pos <= 7'd0;
				end
			end
			
			else
			begin
				if(Y_pos > 7'd0)
				begin
					Y_pos <= Y_pos - 7'd1;
				end
				else
				begin
					Y_pos <= 7'd113;
				end			
			end		
		end
	end	
endmodule
