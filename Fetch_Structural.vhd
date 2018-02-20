--
-- VHDL Architecture my_project_lib.Fetch.Behavior
--
-- Created:
--          by - conno.UNKNOWN (DESKTOP-TFKO3GP)
--          at - 12:12:29 02/ 7/2018
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Fetch IS
  PORT( Jaddr, Mdata : IN std_ulogic_vector(31 DOWNTO 0);
        Address, Inst : OUT std_ulogic_vector(31 DOWNTO 0);
        Clock, Jmp, Reset, Delay : IN std_ulogic;
        Read : OUT std_ulogic);
END ENTITY Fetch;

--
ARCHITECTURE Structural OF Fetch IS
  CONSTANT NOP : std_ulogic_vector(31 DOWNTO 0) := "00000000000000000000000000010011";
  SIGNAL Delay_Jmp : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL Jmp_PC : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL Read_Addr : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL Addr_Inc : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL temp1 : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL temp2 : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL PC_Reset : std_ulogic;

BEGIN
    Read <= (Jmp OR Reset) NAND Delay;
    PC_Reset <= (Reset and Clock);
    
  DelaySelect : ENTITY work.Mux2(Behavior2_1)
    GENERIC MAP(width=>32)
    PORT MAP(Sel=>Delay, In1=>Read_Addr, In0=>Addr_Inc, Q=>Delay_Jmp);
  JmpSelect : ENTITY work.Mux2(Behavior2_1)
    GENERIC MAP(width=>32)
    PORT MAP(Sel=>Jmp, In1=>Jaddr, In0=>Delay_Jmp, Q=>Jmp_PC);
  Inc_Init : ENTITY work.Increment(Behavior)
    GENERIC MAP(width=>32)
    PORT MAP(D=>Read_Addr, Q=>Addr_Inc, Inc=>"11");
  Check_Reset : ENTITY work.Mux2(Behavior2_1)
    GENERIC MAP(width=>32)
    PORT MAP(Sel=>Reset, In1=>NOP, In0=>Mdata, Q=>temp1);
  Check_Delay : ENTITY work.Mux2(Behavior2_1)
    GENERIC MAP(width=>32)
    PORT MAP(Sel=>Delay, In1=>NOP, In0=>temp1, Q=>temp2);
  Check_Jmp : ENTITY work.Mux2(Behavior2_1)
    GENERIC MAP(width=>32)
    PORT MAP(Sel=>Jmp, In1=>NOP, In0=>temp2, Q=>Inst);
  Reg_Init : ENTITY work.Reg(Behavior)
    GENERIC MAP(size=>32)
    PORT MAP(D=>Jmp_PC, E=> '1', reset=>PC_Reset, Q=>Read_Addr, Clock=>Clock);
      
  Address <= Read_Addr;
END ARCHITECTURE Structural;

