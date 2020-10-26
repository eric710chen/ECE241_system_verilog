//Seven segment display module
module Seven_seg_display(BIN, HEX);
  input [3:0] BIN;
  output reg [0:6] HEX;

  always @ (*)
    begin
    case(BIN)			 
      4'b0000 : HEX = 7'b1000000;    //0
      4'b0001 : HEX = 7'b1111001;    //1 
      4'b0010 : HEX = 7'b0100100;    //2					 
      4'b0011 : HEX = 7'b0110000;    //3					 
      4'b0100 : HEX  = 7'b0011001;   //4					  
      4'b0101 : HEX  = 7'b0010010;   //5		 			  
      4'b0110 : HEX  = 7'b0000010;   //6					  
		4'b0111 : HEX  = 7'b1111000;   //7					 
      4'b1000 : HEX  = 7'b0000000;   //8					 
      4'b1001 : HEX  = 7'b0010000;   //9
		default: HEX = 7'b1000000;
    endcase
  end
endmodule