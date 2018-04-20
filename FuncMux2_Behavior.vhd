--
-- VHDL Architecture my_project_lib.FuncMux2.Behavior
--
-- Created:
--          by - conno.UNKNOWN (DESKTOP-TFKO3GP)
--          at - 09:45:30 04/ 9/2018
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE work.RV32I.all;

ENTITY FuncMux2 IS
  PORT( In0, In1 : IN RV32I_Op;
        Q : OUT RV32I_Op;
        Sel : IN std_ulogic);
END ENTITY FuncMux2;

--
ARCHITECTURE Behavior OF FuncMux2 IS
BEGIN
  PROCESS (In0, In1, Sel) IS
  BEGIN
    IF (Sel = '0') THEN
      Q <= In0;
    ELSIF (Sel = '1') THEN
      Q <= In1;
    END IF;
  END PROCESS;
END ARCHITECTURE Behavior;


