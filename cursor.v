//This module is used for controlling the horizontal movement of cursor 
module move_x_direction(pulse, dir_in, pix_count);
	input pulse;
	input [1:0]dir_in;	
	output reg [7:0]pix_count;
	
	always@(posedge pulse)
	begin
		if(!dir_in[0])
		begin
			if(pix_count < 8'd152)
			begin
				pix_count <= pix_count + 8'd1;					
			end
			else
			begin
				pix_count <= 8'd0;
			end
		end
		
		else if(!dir_in[1])
		begin
			if(pix_count > 8'd0)
			begin
				pix_count <= pix_count - 8'd1;					
			end
			else
			begin
				pix_count <= 8'd154;
			end
		end

	end

endmodule

//This module is used for controlling the vertical movement of cursor
module move_y_direction(pulse, dir_in, pix_count);
	input pulse;
	input [1:0]dir_in;	
	output reg [6:0]pix_count;
	//Pressing the KEY = 0
	
	always@(posedge pulse)
	begin
		if(!dir_in[0])
		begin
			if(pix_count < 8'd118)
			begin
				pix_count <= pix_count + 7'd1;					
			end
			else
			begin
				pix_count <= 7'd0;
			end
		end
		
		else if(!dir_in[1])
		begin
			if(pix_count > 7'd0)
			begin
				pix_count <= pix_count - 7'd1;					
			end
			else
			begin
				pix_count <= 7'd118;
			end
		end

	end

endmodule

//This module is used for selecting the speed of the cursor
module cursor_pulse(select,clk,Enable,pulse);//SW[4],SW[5] select speed,SW[0] Enable
      input clk,Enable;
		output reg pulse;
		input [1:0]select;
		
		reg [19:0] counter;
		
		always @ (posedge clk)
		begin
		if(!Enable)
		begin
		counter <= 20'b0;
		pulse <= 1'b0;
		end
		else if(Enable)
		     begin
			       if(select == 2'b00)
					    begin
			          counter <= 20'd781249; 
			          
			               if (counter == 20'd0)
								begin
					             counter <= 20'd781249;
					             pulse <= ~pulse;
								end
					         else
					             counter <= counter - 1'b1;
			          end
					 
					 
					 else if(select == 2'b01)
					    begin
						 counter <= 20'd700000;  
						 
						      if (counter == 20'd0)
								begin
								    counter <= 20'd500000;
									 pulse <= ~pulse;
								end
								else
								    counter <= counter - 1'b1;
						 end
					 
					 
					 else if(select == 2'b10)
					    begin
						 counter <= 20'd750000;// 
						 
						      if (counter == 20'd0)
								begin
								    counter <= 20'd600000;
									 pulse <= ~pulse;
								end
								else
								    counter <= counter - 1'b1;
						 end
						 
					 else//select = 2'b11
					    begin
					    counter <= 20'd416000;
						 
						      if (counter == 20'd0)
								begin
								    counter <= 20'd416000;
									 pulse <= ~pulse;
								end
								else
								    counter <= counter - 1'b1;
						 end
			  end
		end
endmodule

//This module is used for draw a 4*4 block as the cursor
module cursor_draw(X_in, Y_in, CLOCK_50, X_out, Y_out, Color_out);	
	input [7:0] X_in;
	input [6:0] Y_in;
	
	input CLOCK_50;
	
	reg [2:0] Color;
	
	output reg [7:0] X_out;
	output reg [6:0] Y_out;
	output [2:0] Color_out;
	

	
	always @(posedge CLOCK_50)
	begin		
		
		if(X_out <= 8'd159)
		begin
			X_out <= X_out + 8'b1;
		end
		else
		begin
			Y_out <= Y_out + 7'b1;
			X_out <= 8'b0;		
		end				
	end
		
	always @(posedge CLOCK_50)
	begin			
		if ((Y_out >= Y_in) && (Y_out < (Y_in + 7'd4)))
		begin
			if((X_out >= X_in) && (X_out < (X_in + 8'd4)))
			begin
				Color <= 3'b101;
			end
			
			else
			begin	
				Color <= 3'b000;
			end
		end
	end
	
	assign Color_out = Color;
endmodule
