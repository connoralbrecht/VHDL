--
-- VHDL Architecture my_project_lib.Reg.Behavior
--
-- Created:
--          by - conno.UNKNOWN (DESKTOP-TFKO3GP)
--          at - 12:56:59 02/ 5/2018
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


ENTITY Reg IS
  GENERIC(size : NATURAL RANGE 1 TO 64 := 8);
  PORT( D : IN std_ulogic_vector(size - 1 DOWNTO 0);
        Q : OUT std_ulogic_vector(size - 1 DOWNTO 0);
        Clock, reset, E : IN std_ulogic);
END ENTITY Reg;
--
ARCHITECTURE Behavior OF Reg IS
  CONSTANT zero_wide : std_ulogic_vector(size - 1 DOWNTO 0) := (others => '0');
BEGIN 
  PROCESS (reset, Clock)
  BEGIN 
    IF(reset = '1') THEN
      Q <= zero_wide;
    ELSIF (rising_edge(Clock) AND E = '1') THEN 
      Q <= D; 
    END IF; 
  END PROCESS; 
END ARCHITECTURE Behavior;

