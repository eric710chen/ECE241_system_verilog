//This module is used for drawing four different shapes on the monitor
module shape_draw(Ctrl_Signal, X_in, Y_in, CLOCK_50, X_out, Y_out, Color_out);
//module shape_draw(Ctrl_Signal, X_in, Y_in, CLOCK_50, X_out, Y_out, Color_out, shape1_wire, shape2_wire, shape3_wire, shape4_wire);
	input [1:0] Ctrl_Signal;
	input [7:0] X_in;
	input [6:0] Y_in;		
	input CLOCK_50;
//	input [2:0] shape1_wire, shape2_wire, shape3_wire, shape4_wire;///////////////////////////////////
	
	reg [2:0] Color_out_wire;
	
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
		//Shape 1
		if(Ctrl_Signal == 2'b00)
		begin
			if ((Y_out >= Y_in) && (Y_out < (Y_in + 7'd12)))//7'd12
			//if ((Y_out >= Y_in) && (Y_out < (Y_in + 7'd14)))
			begin
				if((X_out >= X_in) && (X_out < (X_in + 8'd7)))//8'd7
				//if((X_out >= X_in) && (X_out < (X_in + 8'd14)))
				begin
					Color_out_wire <= 3'b100;//red
					//Color_out_wire <= shape1_wire;
				end
				
				else
				begin	
					Color_out_wire <= 3'b000;
				end
			end
		end
		
		//Shape 2
		else if(Ctrl_Signal == 2'b01)
		begin			
			if ((Y_out >= Y_in) && (Y_out < (Y_in + 7'd8)))//7'd8
			//if ((Y_out >= Y_in) && (Y_out < (Y_in + 7'd14)))
			begin
				if((X_out >= X_in) && (X_out < (X_in + 8'd8)))//8'd8
				//if((X_out >= X_in) && (X_out < (X_in + 8'd14)))
				begin
					Color_out_wire <= 3'b010 ;//green
					//Color_out_wire <= shape2_wire ;
				end
				
				else
				begin	
					Color_out_wire <= 3'b000;
				end				
			end								
		end
		
		//Shape 3
		else if(Ctrl_Signal == 2'b10)
		begin			
			if ((Y_out >= Y_in) && (Y_out < (Y_in + 7'd10)))//7'd10
			//if ((Y_out >= Y_in) && (Y_out < (Y_in + 7'd14)))
			begin
				if((X_out >= X_in) && (X_out < (X_in + 8'd7)))//8'd7
				//if((X_out >= X_in) && (X_out < (X_in + 8'd14)))
				begin
					Color_out_wire <= 3'b011;//cyan 
					//Color_out_wire <= shape3_wire;
				end
				
				else
				begin	
					Color_out_wire <= 3'b000;
				end				
			end								
		end
		
		//Shape 4
		else if(Ctrl_Signal == 2'b11)
		begin			
			if ((Y_out >= Y_in) && (Y_out < (Y_in + 7'd6)))//7'd6
			//if ((Y_out >= Y_in) && (Y_out < (Y_in + 7'd14)))
			begin
				if((X_out >= X_in) && (X_out < (X_in + 8'd10)))//8'd10
				//if((X_out >= X_in) && (X_out < (X_in + 8'd14)))
				begin
					Color_out_wire <= 3'b111;//white
					//Color_out_wire <= shape4_wire;
				end
				
				else
				begin	
					Color_out_wire <= 3'b000;
				end				
			end								
		end
	end//always block #2
	
	assign Color_out = Color_out_wire;
endmodule