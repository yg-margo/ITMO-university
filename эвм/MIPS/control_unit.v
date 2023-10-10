module control_unit(opcode, funct, memtoreg, memwrite, branch, alusrc, regdst, regwrite, alucontrol);
  input [5:0] opcode, funct;
  output reg memtoreg, memwrite, branch, alusrc, regdst, regwrite;
  output reg [2:0] alucontrol;
  reg [1:0] aluop;

  always @ (opcode, funct) begin
    case (opcode)
      6'b000000: begin
        regwrite = 1;
        regdst = 1;
        alusrc = 0;
        branch = 0;
        memwrite = 0;
        memtoreg = 0;
        aluop = 2'b10; 
      end
      
      6'b100011: begin 
        regwrite = 1;
        regdst = 0;
        alusrc = 1
        branch = 0;
        memwrite = 0;
        memtoreg = 1;
        aluop = 2'b00;
      end
      
      6'b101011: begin 
        regwrite = 0;
        alusrc = 1;
        branch = 0;
        memwrite = 1;
        aluop = 2'b00;
      end
      6'b001000: begin 
        regwrite = 1;
        regdst = 0;
        alusrc = 1;
        branch = 0;
        memwrite = 0;
        memtoreg = 0;
        aluop = 2'b00;
      end
      
      6'b000100: begin 
        regwrite = 0;
        alusrc = 0;
        branch = 1;
        memwrite = 0;
        aluop = 2'b01;
      end
    endcase
    
    if (aluop == 2'b00) begin
      alucontrol = 3'b010;
    end else if (aluop[0]) begin
      alucontrol = 3'b110;
    end else begin
      case (funct)
        6'b100000: alucontrol = 3'b010;
        6'b100010: alucontrol = 3'b110;
        6'b100100: alucontrol = 3'b000;
        6'b100101: alucontrol = 3'b001;
        6'b101010: alucontrol = 3'b111;
      endcase
    end
  end
endmodule