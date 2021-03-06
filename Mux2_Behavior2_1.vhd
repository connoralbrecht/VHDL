--
-- VHDL Architecture my_project_lib.Mux2.Behavior2_1
--
-- Created:
--          by - conno.UNKNOWN (DESKTOP-TFKO3GP)
--          at - 12:13:43 02/ 5/2018
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;

ENTITY Mux2 IS
  GENERIC(width : NATURAL RANGE 1 TO 64 := 8);
  PORT( In0, In1 : IN std_ulogic_vector(width - 1 DOWNTO 0);
        Q : OUT std_ulogic_vector(width - 1 DOWNTO 0);
        Sel : IN std_ulogic);
END ENTITY Mux2;
--
ARCHITECTURE Behavior2_1 OF Mux2 IS
  CONSTANT x_wide : std_ulogic_vector(width - 1 DOWNTO 0) := (others => 'X');
BEGIN
  PROCESS (In0, In1, Sel) IS
  BEGIN
    IF (Sel = '0') THEN
      Q <= In0;
    ELSIF (Sel = '1') THEN
      Q <= In1;
    ELSE
      Q <= x_wide;
    END IF;
  END PROCESS;
      
END ARCHITECTURE Behavior2_1;

