--
-- VHDL Architecture my_project_lib.DecPipe.Behavior
--
-- Created:
--          by - conno.UNKNOWN (DESKTOP-TFKO3GP)
--          at - 11:23:00 03/14/2018
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE work.RV32I.all;

ENTITY DecPipe IS
    PORT( Inst, Address, DataA, DataB : IN std_ulogic_vector(31 DOWNTO 0); 
        Left, Right, Extra, Extra2 : OUT std_ulogic_vector(31 DOWNTO 0);
        DestReg  : OUT std_ulogic_vector(4 DOWNTO 0);
        Func : OUT RV32I_Op);
END ENTITY DecPipe;

--
ARCHITECTURE Behavior OF DecPipe IS
  CONSTANT x_wide : std_ulogic_vector(31 DOWNTO 0) := (others => 'X');
  CONSTANT NOP : std_ulogic_vector(31 DOWNTO 0) := "00000000000000000000000000010011";
  SIGNAL AddrA, AddrB : std_ulogic_vector(4 DOWNTO 0);
--  SIGNAL DataA, DataB, PCVal : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL RS1, RS2, RD : std_ulogic_vector(4 DOWNTO 0);
  SIGNAL RS1v, RS2v, RDv : std_ulogic;
  SIGNAL Imm : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL FuncTemp : RV32I_Op;
  SIGNAL I_type  : InsType;
  SIGNAL RSel, E2Sel : std_ulogic;
  SIGNAL ESel, LSel : std_ulogic_vector(1 DOWNTO 0);
    
BEGIN
  DecInst : ENTITY work.Decoder(Behavior)
   -- GENERIC MAP(width=>32)
    PORT MAP(RS1v => RS1v, RS2v => RS2v, RDv => RDv, RS1 => RS1, RS2 => RS2, RD => RD, Imm => Imm, Inst => Inst, Func => FuncTemp, I_type => I_type);
  ExtraMux : ENTITY work.Mux3(Behavioral)
    GENERIC MAP(width=>32)
    PORT MAP(Sel=>ESel, In2 => Imm, In1=>DataB, In0=>x_wide, Q=>Extra);
  Extra2Mux : ENTITY work.Mux2(Behavior2_1)
    GENERIC MAP(width=>32)
    PORT MAP(Sel=>E2Sel, In1=>Address, In0=>x_wide, Q=>Extra2);
  LeftMux : ENTITY work.Mux3(Behavioral)
    GENERIC MAP(width=>32)
    PORT MAP(Sel=>LSel, In2 => DataB, In1=>Imm, In0=>x_wide, Q=>Left);
  RightMux : ENTITY work.Mux2(Behavior2_1)
    GENERIC MAP(width=>32)
    PORT MAP(Sel=>RSel, In1=>DataA, In0=>x_wide, Q=>Right);
  RDMux : ENTITY work.Mux2(Behavior2_1)
    GENERIC MAP(width=>5)
    PORT MAP(Sel=>RDv, In1=>RD, In0=>"XXXXX", Q=>DestReg);
  AddrAMux : ENTITY work.Mux2(Behavior2_1)
    GENERIC MAP(width=>5)
    PORT MAP(Sel=>RS1v, In1=>RS1, In0=>"XXXXX", Q=>AddrA);
  AddrBMux : ENTITY work.Mux2(Behavior2_1)
    GENERIC MAP(width=>5)
    PORT MAP(Sel=>RS2v, In1=>RS2, In0=>"XXXXX", Q=>AddrB);
  /*Reg_Init : ENTITY work.Reg(Behavior)
    GENERIC MAP(size=>32)
    PORT MAP(D=>Address, E=> '1', reset=>reset, Q=>PCVal, Clock=>Clock);*/
  PROCESS (FuncTemp) IS 
  BEGIN
    Func <= FuncTemp;
    CASE I_type IS
      WHEN R =>
        RSel <= '1';
        ESel <= "00";
        E2Sel <= '0'; 
        IF RS2v = '0' THEN
          LSel <= "00";
        ELSE
          LSel <= "10"; 
        END IF;     
      WHEN I =>
        RSel <= '1';
        ESel <= "00";
        E2Sel <= '0'; 
        LSel <= "01";  
      WHEN S =>
        RSel <= '1';
        ESel <= "01";
        E2Sel <= '0'; 
        LSel <= "01"; 
      WHEN SB =>
        RSel <= '1';
        ESel <= "10";
        E2Sel <= '1'; 
        LSel <= "10"; 
      WHEN U =>
        RSel <= '0';
        ESel <= "10";
        E2Sel <= '0'; 
        LSel <= "00"; 
      WHEN UJ =>
        RSel <= '0';
        ESel <= "10";
        E2Sel <= '0'; 
        LSel <= "00"; 
      WHEN OTHERS =>
        RSel <= '0';
        ESel <= "00";
        E2Sel <= '0'; 
        LSel <= "00";  
    END CASE; 
    IF FuncTemp = BAD THEN
        RSel <= '0';
        ESel <= "00";
        E2Sel <= '0'; 
        LSel <= "00";
    END IF;
    IF Inst = NOP THEN
        RSel <= '0';
        ESel <= "00";
        E2Sel <= '0'; 
        LSel <= "00";
    END IF;                                 
  END PROCESS;
      
END ARCHITECTURE Behavior;

