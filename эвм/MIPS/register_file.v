module register_file(clk, we3, a1, a2, a3, wd3, rd1, rd2);
  input clk, we3;
  input [4:0] a1, a2, a3;
  input [31:0] wd3;
  output [31:0] rd1, rd2;
  
  reg [31:0] reg_mem [0:31];
  
	initial 
		begin
			$readmemb("registers.dat", reg_mem);
		end
		
	
	assign rd1 = reg_mem[a1];
	assign rd2 = reg_mem[a2];
	
	always @(posedge clk) begin
		if (we3 == 1)
			reg_mem[a3] = wd3;
	end	
endmodule