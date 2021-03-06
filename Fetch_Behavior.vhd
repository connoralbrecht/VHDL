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
ARCHITECTURE Behavior OF Fetch IS
  CONSTANT long_zero : std_ulogic_vector(31 DOWNTO 0) := (others => '0');
  CONSTANT NOP : std_ulogic_vector(31 DOWNTO 0) := "00000000000000000000000000010011";
BEGIN
  PROCESS(Reset, Delay, Jmp) IS --Inst Func
  BEGIN
    IF(Reset = '0' AND Delay = '0' AND Jmp = '0') THEN
      Inst <= Mdata;
    ELSE
      Inst <= NOP;
    END IF;
  END PROCESS;
  
  PROCESS(Reset, Delay, Jmp) IS --Read Func
  BEGIN
    IF((Reset = '1' OR Jmp = '1') NAND Delay = '1') THEN
      Read <= '1';
    ELSE 
      Read <= '0';
    END IF;
  END PROCESS;
  
  PROCESS(Reset, Clock, Delay, Jmp) IS --Reg File
  VARIABLE Reg_Out : std_ulogic_vector(31 DOWNTO 0) := (others => '0');
  BEGIN
    IF(rising_edge(Clock) AND Reset = '1') THEN
      Reg_Out := long_zero;
      Address <= long_zero;
    ELSIF(rising_edge(Clock) AND Reset = '0' AND Jmp = '1') THEN 
      Address <= Jaddr;
      Reg_Out := std_ulogic_vector(UNSIGNED (Jaddr) + 4);
    ELSIF(rising_edge(Clock) AND Reset = '0' AND Jmp = '0' AND Delay = '0') THEN 
      Address <= Reg_Out;
      Reg_Out := std_ulogic_vector(UNSIGNED (Reg_Out) + 4); 
    ELSIF(rising_edge(Clock) AND Reset = '0' AND Jmp = '0' AND Delay = '1') THEN 
      Reg_Out := Reg_Out;
    END IF; 
  END PROCESS;
  
END ARCHITECTURE Behavior;