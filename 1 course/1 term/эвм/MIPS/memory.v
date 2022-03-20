module data_memory(a, we, clk, wd, rd);
  input we, clk;
  input [31:0] a;
  input [31:0] wd;
  output reg [31:0] rd;
  
  reg [31:0] ram[63:0];

  initial 
	   begin
      $readmemb("data_memory.dat", ram);
		end
 
  always @ (posedge clk) begin
		if (we == 1)
			ram[a/4] <= wd;
	end
	
   always @(*) begin
		rd <= ram[a/4];
  end
endmodule



module instruction_memory(a, rd);
  input [31:0] a;
  output reg [31:0] rd;
  
  
  reg [31:0] ram[63:0];

  initial
    begin
      $readmemb("instructions.dat", ram);
    end

  always @(*) begin
		rd <= ram[a/4];
  end
  
endmodule
