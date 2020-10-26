/*
SW[9] reset
SW[7] Enable the cursor movement
SW[1] Animation Enable
SW[0] Control the movement of shapes (up or down)
SW[8] Start the game clock
KEY[3:0] Control Cursor movement
*/

//Top_Level module
module fill
	(
		LEDR,
		HEX0,
		HEX1,
		HEX4,
		HEX5,
		CLOCK_50,						//	On Board 50 MHz
		KEY,							//	Push Button[3:0]
		SW,								//	DPDT Switch[9:0]
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);	
	
	output [0:0] LEDR;
	input			CLOCK_50;				//	50 MHz				
	input	[3:0]	KEY;					//	Button[3:0]
	input	[9:0]	SW;						//	Switches[0:0]
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	output [6:0] HEX0, HEX1, HEX4, HEX5;
	
	wire resetn;
	assign resetn = ~SW[9];


	wire [2:0] color;
	wire [7:0] x_plot;
	wire [6:0] y_plot;
	wire [1:0] Ctrl_Sig;
	
	/////////Cursor Movement//////////////////////////////
	wire Cursor_pulse;
	
	wire [7:0] X_Cursor_in;
	wire [6:0] Y_Cursor_in;
	
	wire [7:0] X_Cursor_out;
	wire [6:0] Y_Cursor_out;
	 
	wire [2:0] Cursor_Color;
	
	
	cursor_pulse C1(CLOCK_50, Cursor_pulse, SW[7]);//SW[7] enables the cursor signal
	move_x_direction x_pos(Cursor_pulse, KEY[3:2], X_Cursor_in);
	move_y_direction y_pos(Cursor_pulse, KEY[1:0], Y_Cursor_in);
   cursor_draw cursor(X_Cursor_in[7:0], Y_Cursor_in[6:0], CLOCK_50,X_Cursor_out[7:0], Y_Cursor_out[6:0], Cursor_Color[2:0]);	

	/////////Draw and Move Shapes///////////////////////////
	wire Animation_pulse;
	wire [7:0] X_Shape_in;
	wire [6:0] Y_Shape_in;
	wire [7:0] X_Shape_out;
	wire [6:0] Y_Shape_out;
	wire [2:0] Shape_colour;
	
	Animation_Signal A1(CLOCK_50, Animation_pulse, SW[8]);	
	Animation A2(Animation_pulse, SW[1], SW[0] , X_Shape_in, Y_Shape_in, Ctrl_Sig);//SW[1] enable SW[0] up_down
	shape_draw A3(Ctrl_Sig, X_Shape_in[7:0], Y_Shape_in[6:0], CLOCK_50, X_Shape_out[7:0], Y_Shape_out[6:0],Shape_colour[2:0]);
	//shape1_wire[2:0],shape2_wire[2:0],shape3_wire[2:0],shape4_wire[2:0]
	
//////////////colour from mif////////////////////////////////
/*   wire [2:0] q1,q2,q3,q4;
   reg [2:0] shape1_wire,shape2_wire,shape3_wire,shape4_wire;
   reg [7:0] address1_wire,address2_wire,address3_wire,address4_wire;
   
   shape1 s1(address1_wire,CLOCK_50,3'b000,1'b0,q1);
   always @ (posedge CLOCK_50)
   begin
        address1_wire <= 8'd0;
		  if(address1_wire <= 8'd196)
		  begin
		       shape1_wire[2:0] <= q1[2:0];
				 address1_wire <= address1_wire + 1'b1;
		  end
		  else
		       address1_wire <= 8'b0;
	end
   
   shape2 s2(address2_wire,CLOCK_50,3'b000,1'b0,q2);
   always @ (posedge CLOCK_50)
   begin
        address2_wire <= 8'd0;
		  if(address2_wire <= 8'd196)
		  begin
		       shape2_wire[2:0] <= q2[2:0];
				 address2_wire <= address2_wire + 1'b1;
		  end
		  else
		       address2_wire <= 8'b0;
	end	
	
	shape3 s3(address3_wire,CLOCK_50,3'b000,1'b0,q3);
   always @ (posedge CLOCK_50)
   begin
        address3_wire <= 8'd0;
		  if(address3_wire <= 8'd196)
		  begin
		       shape3_wire[2:0] <= q3[2:0];
				 address3_wire <= address3_wire + 1'b1;
		  end
		  else
		       address3_wire <= 8'b0;
	end
	
	shape4 s4(address4_wire,CLOCK_50,3'b000,1'b0,q4);
   always @ (posedge CLOCK_50)
   begin
        address4_wire <= 8'd0;
		  if(address4_wire <= 8'd196)
		  begin
		       shape4_wire[2:0] <= q4[2:0];
				 address4_wire <= address4_wire + 1'b1;
		  end
		  else
		       address4_wire <= 8'b0;
	end
	
*/	
/////////////////////////////////////////////////////////
/*


In order to make sure there is only one set of color,x_plot,y_plot signals entering the VGA module
we need to separate the ploting of shape and cursor


*/  
	reg [7:0] x_plot_wire;
	reg [6:0] y_plot_wire;
	reg [2:0] color_wire;
	
	always @(posedge CLOCK_50)
	begin		
		if((Cursor_Color != 3'b000) && (Shape_colour == 3'b000))
		begin
			x_plot_wire <= X_Cursor_out;
			y_plot_wire <= Y_Cursor_out;
			color_wire <= Cursor_Color;
		end
		
		else if((Shape_colour != 3'b000) && (Cursor_Color == 3'b000))
		begin
			x_plot_wire <= X_Shape_out;
			y_plot_wire <= Y_Shape_out;
			color_wire <= Shape_colour;
		end
		
		else 
		begin		
			x_plot_wire <= X_Cursor_out;
			y_plot_wire <= Y_Cursor_out;	
			color_wire <= 3'b000;
		end	
	end
	
	assign x_plot = x_plot_wire;
	assign y_plot = y_plot_wire;
	assign color = color_wire;

	
	
///////////////////////Game_Clock///////////////////////////////
	wire Game_clk_sig;
	reg [3:0] ones;
	reg [3:0] tens;
	
	GameCounter U1(CLOCK_50, Game_clk_sig, SW[8]);//SW[8] start the game_Clock
	

	always @(posedge Game_clk_sig)
	begin
		ones <= ones + 4'b0001;//
		
		if(ones == 4'b1001)//reach 9
		begin
			ones <= 4'b0000;//reset ones
			tens <= tens + 4'b0001;//tens add 1
		end	
		
		if(tens == 4'b0110)//reach 6 reset the game_clock
		begin
			ones <= 4'b0000;
			tens <= 4'b0000;
			
		end

	end

//////////////Game_Time_Display/////////////////////////////
	Seven_seg_display H1 (tens[3:0], HEX1);
	Seven_seg_display H0 (ones[3:0], HEX0);
	
	
	assign LEDR[0] = ((Cursor_Color != 3'b000) && (Shape_colour != 3'b000));
	
/////////////Game_Point_Calculation/////////////////////////		
	reg [3:0] points_ones;
	reg [3:0] points_tens;
	reg [9:0] temp;
	
	always@(negedge LEDR[0]) //1 -> 0 cursor leaves the shape
	begin				
		if(temp >= 10'd1000)
			temp <= temp;
		else			
			temp <= temp + 4'b0001; 
		
		
		if(temp >= 10'd500)
		begin
			points_ones <= points_ones + 4'b0001;
			temp <= 4'b0000;
		end
		else
		begin
			points_ones <= points_ones;
		end
		
		
		if(points_ones > 4'b1001)
		begin
			points_ones <= 4'b0000;
			points_tens <= points_tens + 4'b0001;
		end	
		
		if(points_tens == 4'b0110)
		begin
			points_ones <= 4'b0000;
			points_tens <= 4'b0000;		
		end
	
	end	
	///////////////////Game_Point_Display//////////////////////
	
	Seven_seg_display H5 (points_tens[3:0], HEX5);
	Seven_seg_display H4 (points_ones[3:0], HEX4);
	
	
	////////////////////VGA ADAPTER Module//////////////////////
	
	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(color),
			.x(x_plot),
			.y(y_plot),
			.plot(1'b1),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "<black.mif>";			
	
	
endmodule


