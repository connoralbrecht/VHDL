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
USE work.RV32I.all;

ENTITY FuncReg IS

  PORT( FuncIn : IN RV32I_Op; --from decode to memory
        FuncOut : OUT RV32I_Op; --from decode to memory
        Clock, reset, E : IN std_ulogic);
END ENTITY FuncReg;
--
ARCHITECTURE Behavior OF FuncReg IS
BEGIN 
  PROCESS (reset, Clock)
  BEGIN 
    IF(reset = '1') THEN
      FuncOut <= BAD;
    ELSIF (rising_edge(Clock) AND E = '1') THEN 
      FuncOut <= FuncIn; 
    END IF; 
  END PROCESS; 
END ARCHITECTURE Behavior;


