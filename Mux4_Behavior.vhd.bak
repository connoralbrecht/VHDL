--
-- VHDL Architecture my_project_lib.Mux4.Behavior
--
-- Created:
--          by - conno.UNKNOWN (DESKTOP-TFKO3GP)
--          at - 15:07:29 02/ 5/2018
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY Mux4 IS
  GENERIC(width : NATURAL RANGE 1 TO 64 := 8);
  PORT( In0, In1, In2, In3 : IN std_ulogic_vector(width - 1 DOWNTO 0);
        Q : OUT std_ulogic_vector(width - 1 DOWNTO 0);
        Sel : IN std_ulogic_vector(1 DOWNTO 0));
END ENTITY Mux4;

--
ARCHITECTURE Behavior OF Mux4 IS
  CONSTANT x_wide : std_ulogic_vector(width - 1 DOWNTO 0) := (others => 'X');
BEGIN
  PROCESS (In0, In1, In2, In3, Sel) IS
  BEGIN
    IF (Sel = "00") THEN
      Q <= In0;
    ELSIF (Sel = "01") THEN
      Q <= In1;
    ELSIF (Sel = "10") THEN
      Q <= In2;
    ELSIF (Sel = "11") THEN
      Q <= In3;
    ELSE
      Q <= x_wide;
    END IF;
  END PROCESS;
END ARCHITECTURE Behavior;