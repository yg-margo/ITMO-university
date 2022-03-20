`include "alu.v"
`include "control_unit.v"
`include "util.v"


module mips_cpu(clk, instruction_memory_a, instruction_memory_rd, data_memory_a, data_memory_rd, data_memory_we, data_memory_wd,
                register_a1, register_a2, register_a3, register_we3, register_wd3, register_rd1, register_rd2);
input clk;
output reg data_memory_we;
output reg [31:0] instruction_memory_a, data_memory_a, data_memory_wd;
output reg [31:0] instruction_memory_rd, data_memory_rd;
output reg register_we3;
output reg [4:0] register_a1, register_a2, register_a3;
output reg [31:0] register_wd3;
output reg [31:0] register_rd1, register_rd2;



wire 	[2:0] 	alucontrol;
wire 	[31:0] 	Instr;
wire				RegWrite, MemWrite, RegDst, ALUSrc, MemtoReg, Branch, PCSrc, Zero;
wire 	[31:0]	SrcA, SrcB, rd1, rd2, Signimm, Signimm_sh, ReadData, Result, PCBranch;
wire	[31:0]	ALUResult;
wire	[4:0]		a3;
				
wire	[31:0]	rPC;
wire	[31:0]	PCPlus4;
wire	[31:0]	rPC1;


always @(*)
begin
instruction_memory_a = rPC;
instruction_memory_rd = Instr;
data_memory_a = ALUResult;
data_memory_rd = ReadData;
data_memory_we = MemWrite;
data_memory_wd = rd2;
register_a1 = Instr[25:21];
register_a2 = Instr[20:16];
register_a3 = a3;
register_we3 = RegWrite;
register_wd3 = Result;
register_rd1 = SrcA;
register_rd2 = rd2;
end



assign a3 = (RegDst) ? Instr[15:11] : Instr[20:16];
assign SrcB = (ALUSrc) ? Signimm : rd2;
assign Result = (MemtoReg) ? ReadData : ALUResult; 
assign PCSrc = Branch & Zero;
assign rPC1	=	(PCSrc) ? PCBranch : PCPlus4;
assign PCBranch = {Signimm[29:0], 2'b00} + PCPlus4;


assign PCPlus4 = rPC + 3'd4;

d_flop d_flop_inst
(
	.d			(rPC1), 
	.clk		(clk), 
	.q			(rPC)
);


alu alu_inst
(
	.srca			(SrcA), 
	.srcb			(SrcB),
	
	.alucontrol	(alucontrol),
	.aluresult	(ALUResult),
	.zero			(Zero)
);
 
 
control_unit control_unit_inst
(
	.opcode		(Instr[31:26]), 
	.funct		(Instr[5:0]),
	
	.memtoreg	(MemtoReg), 
	.memwrite	(MemWrite), 
	.branch		(Branch), 
	.alusrc		(ALUSrc), 
	.regdst		(RegDst), 
	.regwrite	(RegWrite),
	
	.alucontrol	(alucontrol)
);
 
 
instruction_memory	instruction_memory_inst
(
	.a			(rPC),
	.rd		(Instr)
 
);
  
  
  
register_file	register_file_inst
(
	.clk			(clk), 
	.we3			(RegWrite), 
	
	.a1			(Instr[25:21]), 
	.a2			(Instr[20:16]), 
	.a3			(a3), 
	
	.wd3			(Result),
	.rd1			(SrcA), 
	.rd2			(rd2)
);
 

data_memory		data_memory_inst
(
	.a				(ALUResult), 
	.we			(MemWrite), 
	.clk			(clk), 
	.wd			(rd2), 
	.rd			(ReadData)
	
);


sign_extend sign_extend_nist
(
	.in			(Instr[15:0]),
	.out			(Signimm)
);


  
endmodule
