--
-- VHDL Architecture my_project_lib.Increment.Behavior
--
-- Created:
--          by - conno.UNKNOWN (DESKTOP-TFKO3GP)
--          at - 15:12:09 02/ 5/2018
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Increment IS
  GENERIC(width : NATURAL RANGE 1 TO 64 := 8);
  PORT( D : IN std_ulogic_vector(width - 1 DOWNTO 0);
        Q : OUT std_ulogic_vector(width - 1 DOWNTO 0);
        Inc : IN std_ulogic_vector(1 DOWNTO 0));
END ENTITY Increment;

--
ARCHITECTURE Behavior OF Increment IS
  CONSTANT x_wide : std_ulogic_vector(width - 1 DOWNTO 0) := (others => 'X');
BEGIN
  PROCESS (D, Inc) IS
  BEGIN
    IF (Inc = "00") THEN
      Q <= D;
    ELSIF (Inc = "01") THEN
      Q <= std_ulogic_vector(UNSIGNED (D) + 1);
    ELSIF (Inc = "10") THEN
      Q <= std_ulogic_vector(UNSIGNED (D) + 2);
    ELSIF (Inc = "11") THEN
      Q <= std_ulogic_vector(UNSIGNED (D) + 4);
    ELSE
      Q <= x_wide;
    END IF;
  END PROCESS;
END ARCHITECTURE Behavior;

