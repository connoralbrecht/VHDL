--
-- VHDL Architecture my_project_lib.Counter.Behavior
--
-- Created:
--          by - conno.UNKNOWN (DESKTOP-TFKO3GP)
--          at - 15:11:33 02/ 5/2018
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Counter IS
  GENERIC(width : NATURAL RANGE 1 TO 64 := 8);
  PORT( D : IN std_ulogic_vector(width - 1 DOWNTO 0);
        Q : OUT std_ulogic_vector(width - 1 DOWNTO 0);
        Clock, enable, reset : IN std_ulogic);
END ENTITY Counter;

--
ARCHITECTURE Behavior OF Counter IS
  CONSTANT long_zero : std_ulogic_vector(width - 1 DOWNTO 0) := (others => '0');
  SIGNAL Inc_Out : std_ulogic_vector(width - 1 DOWNTO 0);
  SIGNAL Reg_D : std_ulogic_vector(width - 1 DOWNTO 0);
  SIGNAL Reg_Out : std_ulogic_vector(width - 1 DOWNTO 0);
  SIGNAL E_Out : std_ulogic_vector(width - 1 DOWNTO 0);
BEGIN
  ResetSelect : ENTITY work.Mux2(Behavior2_1)
    GENERIC MAP(width=>width)
    PORT MAP(Sel=>reset, In1=>long_zero, In0=>E_Out, Q=>Reg_D);
  EnableSelect : ENTITY work.Mux2(Behavior2_1)
    GENERIC MAP(width=>width)
    PORT MAP(Sel=>enable, In1=>Inc_Out, In0=>Reg_Out, Q=>E_Out);
  Inc_Init : ENTITY work.Increment(Behavior)
    GENERIC MAP(width=>width)
    PORT MAP(Inc=>"11", D=>Reg_Out, Q=>Inc_Out);
  Reg_Init : ENTITY work.Reg(Behavior)
    GENERIC MAP(size=>width)
    PORT MAP(D=>Reg_D, E=> '1', reset=>'0', Q=>Reg_Out, Clock=>Clock);
  
  Q <= Reg_Out;
END ARCHITECTURE Behavior;

