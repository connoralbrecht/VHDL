--
-- VHDL Architecture my_project_lib.Mux3.Behavioral
--
-- Created:
--          by - conno.UNKNOWN (DESKTOP-TFKO3GP)
--          at - 12:53:10 02/ 5/2018
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY Mux3 IS
  GENERIC(width : NATURAL RANGE 1 TO 64 := 8);
  PORT( In0, In1, In2 : IN std_ulogic_vector(width - 1 DOWNTO 0);
        Q : OUT std_ulogic_vector(width - 1 DOWNTO 0);
        Sel : IN std_ulogic_vector(1 DOWNTO 0));
END ENTITY Mux3;

--
ARCHITECTURE Behavioral OF Mux3 IS
  CONSTANT x_wide : std_ulogic_vector(width - 1 DOWNTO 0) := (others => 'X');
BEGIN
  PROCESS (In0, In1, In2, Sel) IS
  BEGIN
    IF (Sel = "00") THEN
      Q <= In0;
    ELSIF (Sel = "01") THEN
      Q <= In1;
    ELSIF (Sel = "10") THEN
      Q <= In2;
    ELSE
      Q <= x_wide;
    END IF;
  END PROCESS;
  
END ARCHITECTURE Behavioral;
