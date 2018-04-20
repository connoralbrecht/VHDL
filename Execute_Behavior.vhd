--
-- VHDL Architecture my_project_lib.Execute.Behavior
--
-- Created:
--          by - conno.UNKNOWN (DESKTOP-TFKO3GP)
--          at - 12:30:47 03/27/2018
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE work.RV32I.all;

ENTITY Execute IS
    PORT( Address, Data : OUT std_ulogic_vector(31 DOWNTO 0); -- to memory 
      Clock : IN std_ulogic;
      Left, Right, Extra : IN std_ulogic_vector(31 DOWNTO 0); --from decode stage
      DestRegIn  : IN std_ulogic_vector(4 DOWNTO 0); --from decode to memory
      DestRegOut  : OUT std_ulogic_vector(4 DOWNTO 0); --from decode to memory
      FuncIn : IN RV32I_Op; --from decode to memory
      FuncOut : OUT RV32I_Op; --from decode to memory
      Jaddr : OUT std_ulogic_vector(31 DOWNTO 0); --back to fetch
      Jmp : OUT std_ulogic);
END ENTITY Execute;

--
ARCHITECTURE Behavior OF Execute IS
  CONSTANT x_wide : std_ulogic_vector(31 DOWNTO 0) := (others => 'X');
  --CONSTANT NOP_const : std_ulogic_vector(31 DOWNTO 0) := "00000000000000000000000000010011";
  CONSTANT long_zero : std_ulogic_vector(31 DOWNTO 0) := "00000000000000000000000000000000";
  CONSTANT long_one : std_ulogic_vector(31 DOWNTO 0) := "00000000000000000000000000000001";
  SIGNAL currLeft, currRight, currExtra, ALU_result : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL currDest : std_ulogic_vector(4 DOWNTO 0);
  SIGNAL currFunc : RV32I_Op;
  SIGNAL ALU_In : ALU_Op; 
  SIGNAL ALU_Zero : std_ulogic;
BEGIN

  LeftReg : ENTITY work.Reg(Behavior)
    GENERIC MAP(size=>32)
    PORT MAP(D=>Left, Q=>currLeft, E=> '1', reset=>'0',  Clock=>Clock);  
  RightReg : ENTITY work.Reg(Behavior)
    GENERIC MAP(size=>32)
    PORT MAP(D=>Right, Q=>currRight, E=> '1', reset=>'0',  Clock=>Clock);  
  ExtraReg : ENTITY work.Reg(Behavior)
    GENERIC MAP(size=>32)
    PORT MAP(D=>Extra, Q=>currExtra, E=> '1', reset=>'0',  Clock=>Clock);     
  FunctReg : ENTITY work.FuncReg(Behavior)
    PORT MAP(FuncIn=>FuncIn, FuncOut=>currFunc, E=> '1', reset=>'0',  Clock=>Clock);  
  DestReg : ENTITY work.Reg(Behavior)
    GENERIC MAP(size=>5)
    PORT MAP(D=>DestRegIn, Q=>currDest, E=> '1', reset=>'0',  Clock=>Clock);           
  ALU_stage : ENTITY work.ALU(Behavior)
    PORT MAP(DataA => currRight, DataB => currLeft, ALU => ALU_In, DataOut => ALU_result, DataOut_Zero => ALU_Zero);
  
  FuncOut <= currFunc;
  DestRegOut <= currDest;
      
  PROCESS (currLeft, currRight, currExtra, currFunc, ALU_result) IS
  BEGIN 
    CASE currFunc IS
      --U type
      WHEN LUI => 
        Data <= currLeft; 
        Jaddr <= x_wide;
        Jmp <= '0';
        Address <= x_wide;                
      WHEN AUIPC => 
        ALU_In <= aADD;
        Data <= ALU_result; 
        Jaddr <= x_wide;
        Jmp <= '0';
        Address <= x_wide;        
      --J type  
      WHEN JAL => 
        ALU_In <= aADD;
        Data <= currExtra; 
        Jaddr <= ALU_result;
        Jmp <= '1';
        Address <= x_wide;      
      --I type  
      WHEN JALR => 
        ALU_In <= aADD;
        Data <= currExtra; 
        Jaddr <= ALU_result;
        Jaddr(0) <= '0';
        Jmp <= '1';
        Address <= x_wide;

       --BRANCHES (B type) 
      WHEN BEQ =>
        ALU_In <= aSUB;
        IF ALU_Zero = '1' THEN
          Jmp <= '1';
        ELSE
          Jmp <= '0';
        END IF;
        Data <= x_wide; 
        Jaddr <= currExtra;
        Address <= x_wide; 
      WHEN BNE =>
        ALU_In <= aSUB;
        IF ALU_Zero = '1' THEN
          Jmp <= '0';
        ELSE
          Jmp <= '1';
        END IF;
        Data <= x_wide; 
        Jaddr <= currExtra;
        Address <= x_wide; 
      WHEN BLT =>
        ALU_In <= aSUB;
        IF ALU_Result(31) = '1' THEN
          Jmp <= '1';
        ELSE
          Jmp <= '0';
        END IF;
        Data <= x_wide; 
        Jaddr <= currExtra;
        Address <= x_wide; 
      WHEN BGE =>
        ALU_In <= aSUB;
        IF ALU_Result(31) = '1' THEN
          Jmp <= '0';
        ELSE
          Jmp <= '1';
        END IF;
        Data <= x_wide; 
        Jaddr <= currExtra;
        Address <= x_wide; 
      WHEN BLTU =>
        ALU_In <= aSUB;
        IF ALU_Result(31) = '1' THEN
          Jmp <= '1';
        ELSE
          Jmp <= '0';
        END IF;
        Data <= x_wide; 
        Jaddr <= currExtra;
        Address <= x_wide; 
      WHEN BGEU =>
        ALU_In <= aSUB;
        IF ALU_Result(31) = '1' THEN
          Jmp <= '0';
        ELSE
          Jmp <= '1';
        END IF;
        Data <= x_wide; 
        Jaddr <= currExtra;
        Address <= x_wide; 
        
      --LOADs (I type)
      WHEN LB =>
        ALU_In <= aADD;
        Data <= x_wide; 
        Jaddr <= x_wide;
        Jmp <= '0';
        Address <= ALU_Result;
      WHEN LH =>
        ALU_In <= aADD;
        Data <= x_wide; 
        Jaddr <= x_wide;
        Jmp <= '0';
        Address <= ALU_Result;
      WHEN LW =>
        ALU_In <= aADD;
        Data <= x_wide; 
        Jaddr <= x_wide;
        Jmp <= '0';
        Address <= ALU_Result;
      WHEN LBU =>
        ALU_In <= aADD;
        Data <= x_wide; 
        Jaddr <= x_wide;
        Jmp <= '0';
        Address <= ALU_Result;
      WHEN LHU =>
        ALU_In <= aADD;
        Data <= x_wide; 
        Jaddr <= x_wide;
        Jmp <= '0';
        Address <= ALU_Result;        
        --STORES (S type)
      WHEN SB =>
        ALU_In <= aADD; 
        Data <= currExtra; 
        Jaddr <= x_wide;
        Jmp <= '0';
        Address <= ALU_Result;
      WHEN SH =>
        ALU_In <= aADD; 
        Data <= currExtra; 
        Jaddr <= x_wide;
        Jmp <= '0';
        Address <= ALU_Result;
      WHEN SW =>
        ALU_In <= aADD; 
        Data <= currExtra; 
        Jaddr <= x_wide;
        Jmp <= '0';
        Address <= ALU_Result;        
      --I type
      WHEN ADDI =>
        ALU_In <= aADD;
        Data <= ALU_result; 
        Jaddr <= x_wide;
        Jmp <= '0';
        Address <= x_wide;
      WHEN SLTI => 
        ALU_In <= aSUB;
        IF ALU_Result(31) = '1' THEN
          Data <= long_one;
        ELSE
          Data <= long_zero;
        END IF;
        Jaddr <= x_wide;
        Jmp <= '0';
        Address <= x_wide;
      WHEN SLTIU => 
        ALU_In <= aSUB;
        IF ALU_Result(31) = '1' THEN
          Data <= long_one;
        ELSE
          Data <= long_zero;
        END IF;
        Jaddr <= x_wide;
        Jmp <= '0';
        Address <= x_wide;
      WHEN XORI =>
        ALU_In <= aXOR;
        Data <= ALU_result; 
        Jaddr <= x_wide;
        Jmp <= '0';
        Address <= x_wide;
      WHEN ORI =>
        ALU_In <= aOR;
        Data <= ALU_result; 
        Jaddr <= x_wide;
        Jmp <= '0';
        Address <= x_wide;
      WHEN ANDI =>
        ALU_In <= aAND;
        Data <= ALU_result; 
        Jaddr <= x_wide;
        Jmp <= '0';
        Address <= x_wide;        
      WHEN SLLI => --shift
        ALU_In <= aSL;
        Data <= ALU_result; 
        Jaddr <= x_wide;
        Jmp <= '0';
        Address <= x_wide;
      WHEN SRLI => --shift
        ALU_In <= aSRL;
        Data <= ALU_result; 
        Jaddr <= x_wide;
        Jmp <= '0';
        Address <= x_wide;
      WHEN SRAI => --shift
        ALU_In <= aSRA;
        Data <= ALU_result; 
        Jaddr <= x_wide;
        Jmp <= '0';
        Address <= x_wide;        
      --R type
      WHEN ADDr =>
        ALU_In <= aADD;
        Data <= ALU_result; 
        Jaddr <= x_wide;
        Jmp <= '0';
        Address <= x_wide;
      WHEN SUBr =>
        ALU_In <= aSUB;
        Data <= ALU_result; 
        Jaddr <= x_wide;
        Jmp <= '0';
        Address <= x_wide;
      WHEN SLLr => --shift
        ALU_In <= aSL;
        Data <= ALU_result; 
        Jaddr <= x_wide;
        Jmp <= '0';
        Address <= x_wide;       
      WHEN SLTr => 
        ALU_In <= aSUB;
        IF ALU_Result(31) = '1' THEN
          Data <= long_one;
        ELSE
          Data <= long_zero;
        END IF;
        Jaddr <= x_wide;
        Jmp <= '0';
        Address <= x_wide;
      WHEN SLTUr => 
        ALU_In <= aSUB;
        IF ALU_Result(31) = '1' THEN
          Data <= long_one;
        ELSE
          Data <= long_zero;
        END IF;
        Jaddr <= x_wide;
        Jmp <= '0';
        Address <= x_wide;         
      WHEN XORr =>
        ALU_In <= aXOR;
        Data <= ALU_result; 
        Jaddr <= x_wide;
        Jmp <= '0';
        Address <= x_wide;        
      WHEN SRLr => --shift
        ALU_In <= aSRL;
        Data <= ALU_result; 
        Jaddr <= x_wide;
        Jmp <= '0';
        Address <= x_wide;
      WHEN SRAr => --shift
        ALU_In <= aSRA;
        Data <= ALU_result; 
        Jaddr <= x_wide;
        Jmp <= '0';
        Address <= x_wide;      
      WHEN ORr =>
        ALU_In <= aOR;
        Data <= ALU_result; 
        Jaddr <= x_wide;
        Jmp <= '0';
        Address <= x_wide;
      WHEN ANDr =>
        ALU_In <= aAND;
        Data <= ALU_result; 
        Jaddr <= x_wide;
        Jmp <= '0';
        Address <= x_wide;
              
      --others
      WHEN NOP =>
        ALU_In <= aADD;
        Data <= x_wide; 
        Jaddr <= x_wide;
        Jmp <= '0';
        Address <= x_wide;
      WHEN OTHERS =>
        Data <= x_wide; 
        Jaddr <= x_wide;
        Jmp <= 'X';
        Address <= x_wide;
    END CASE;
  END PROCESS;
END ARCHITECTURE Behavior;

