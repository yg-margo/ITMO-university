module alu(srca, srcb, alucontrol, aluresult, zero);
  input signed [31:0] srca, srcb;
  input [2:0] alucontrol;
  output reg [31:0] aluresult;
  output zero;
  
  assign zero = (aluresult == 0);
	
	always @(alucontrol, srca, srcb) begin
		case (alucontrol)
			3'b000: 	aluresult <= srca & srcb;	//and
			3'b001: 	aluresult <= srca | srcb;	//or
			3'b010:	aluresult <= srca + srcb;	//add
			3'b110:  aluresult <= srca - srcb; 	//sub
			3'b111: aluresult <= srca < srcb ? 1:0; //slt
			default: aluresult <= 0;
		endcase
	end
endmodule

