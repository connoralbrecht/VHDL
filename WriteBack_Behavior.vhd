--
-- VHDL Architecture my_project_lib.WriteBack.Behavior
--
-- Created:
--          by - conno.UNKNOWN (DESKTOP-TFKO3GP)
--          at - 16:01:48 04/ 8/2018
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE work.RV32I.all;

ENTITY WriteBack IS
    PORT( DataIn : IN std_ulogic_vector(31 DOWNTO 0); --from Mem
      DataOut: OUT std_ulogic_vector(31 DOWNTO 0); -- to reg 
      DestRegIn  : IN std_ulogic_vector(4 DOWNTO 0);
      DestRegOut  : OUT std_ulogic_vector(4 DOWNTO 0); 
      FuncIn : IN RV32I_Op; 
      write : OUT std_ulogic; 
      Clock : IN std_ulogic);

END ENTITY WriteBack;

--
ARCHITECTURE Behavior OF WriteBack IS
  SIGNAL currFunc : RV32I_Op;
  SIGNAL currDestReg : std_ulogic_vector(4 DOWNTO 0);
  SIGNAL currData : std_ulogic_vector(31 DOWNTO 0);
BEGIN
  DestReg : ENTITY work.Reg(Behavior)
    GENERIC MAP(size=>5)
    PORT MAP(D=>DestRegIn, Q=>currDestReg, E=> '1', reset=>'0',  Clock=>Clock);
      
  DataReg : ENTITY work.Reg(Behavior)
    GENERIC MAP(size=>32)
    PORT MAP(D=>DataIn, Q=>currData, E=> '1', reset=>'0',  Clock=>Clock);    
     
  FunctReg : ENTITY work.FuncReg(Behavior)
    PORT MAP(FuncIn=>FuncIn, FuncOut=>currFunc, E=> '1', reset=>'0',  Clock=>Clock); 
      
  DataOut <= currData;
  DestRegOut <= currDestReg;
  
  PROCESS(currFunc) IS
  BEGIN
    CASE currFunc IS
      WHEN BEQ TO BGEU | SB TO SW | NOP | BAD =>
        write <= '0';
      WHEN OTHERS =>
        write <= '1';
    END CASE;
  END PROCESS;
          
END ARCHITECTURE Behavior;