--
-- VHDL Architecture my_project_lib.MemPipe.Behavior
--
-- Created:
--          by - conno.UNKNOWN (DESKTOP-TFKO3GP)
--          at - 11:17:45 04/ 5/2018
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE work.RV32I.all;

ENTITY MemPipe IS
    PORT( AddressIn, DataExecuteIn, DataMemIn : IN std_ulogic_vector(31 DOWNTO 0); -- from execute and mem
      AddressOut, DataMemOut, DataWriteBackOut : OUT std_ulogic_vector(31 DOWNTO 0); -- to mem and write back 
      DestRegIn  : IN std_ulogic_vector(4 DOWNTO 0); --from execute
      DestRegOut  : OUT std_ulogic_vector(4 DOWNTO 0); --to write-back
      FuncIn : IN RV32I_Op; --from execute 
      FuncOut : OUT RV32I_Op; --to write-back
      WordSize  : OUT std_ulogic_vector(1 DOWNTO 0); -- byte(00), half-word(01), word(10)  
      read, write, stall : OUT std_ulogic; -- read&write to mem, stall to decode and execute
      Clock, mdelay : IN std_ulogic); --mdelay from mem for stall
       
END ENTITY MemPipe;

--
ARCHITECTURE Behavior OF MemPipe IS
  SIGNAL currFunc : RV32I_Op; 
  SIGNAL currAddress, currData : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL currDestReg : std_ulogic_vector(4 DOWNTO 0);
  SIGNAL EnableSel, FuncSel : std_ulogic;
  CONSTANT x_wide : std_ulogic_vector(31 downto 0) := (others => 'X');
BEGIN
  FunctReg : ENTITY work.FuncReg(Behavior)
    PORT MAP(FuncIn=>FuncIn, FuncOut=>currFunc, E=> EnableSel, reset=>'0',  Clock=>Clock);  
      
  DestReg : ENTITY work.Reg(Behavior)
    GENERIC MAP(size=>5)
    PORT MAP(D=>DestRegIn, Q=>currDestReg, E=> EnableSel, reset=>'0',  Clock=>Clock);
      
  DataReg : ENTITY work.Reg(Behavior)
    GENERIC MAP(size=>32)
    PORT MAP(D=>DataExecuteIn, Q=>currData, E=> EnableSel, reset=>'0',  Clock=>Clock);
    
  AddressReg : ENTITY work.Reg(Behavior)
    GENERIC MAP(size=>32)
    PORT MAP(D=>AddressIn, Q=>currAddress, E=> EnableSel, reset=>'0',  Clock=>Clock); 

  FuncMux : ENTITY work.FuncMux2(Behavior)
    PORT MAP(Sel=>FuncSel, In1=>currFunc, In0=>NOP, Q=>FuncOut);
      
  AddressOut <= currAddress;
  DestRegOut <= currDestReg;
  DataMemOut <= currData;
  
  PROCESS (mdelay) IS
  BEGIN
    stall <= mdelay;
    EnableSel <= NOT mdelay;
    FuncSel <= NOT mdelay;  
  END PROCESS;

  PROCESS (DataMemIn, currFunc, currData, currAddress, currDestReg) IS
  BEGIN
  CASE currFunc IS
    WHEN LW =>
      DataWriteBackOut <= DataMemIn;
      
    WHEN LH =>
      DataWriteBackOut(31 DOWNTO 16) <= (others => DataMemIn(15));
      DataWriteBackOut(15 DOWNTO 0) <= DataMemIn(15 DOWNTO 0);
    WHEN LHU =>
      DataWriteBackOut(31 DOWNTO 16) <= (others => '0');
      DataWriteBackOut(15 DOWNTO 0) <= DataMemIn(15 DOWNTO 0);
        
    WHEN LB =>
      DataWriteBackOut(31 DOWNTO 8) <= (others => DataMemIn(7));
      DataWriteBackOut(7 DOWNTO 0) <= DataMemIn(7 DOWNTO 0);
    WHEN LBU =>
      DataWriteBackOut(31 DOWNTO 8) <= (others => '0');
      DataWriteBackOut(7 DOWNTO 0) <= DataMemIn(7 DOWNTO 0); 
           
    WHEN OTHERS =>
      DataWriteBackOut <= currData;
  END CASE;       
  END PROCESS;
  
  PROCESS (currFunc, currData, currDestReg, currAddress) IS
  BEGIN
  CASE currFunc IS
    WHEN SB TO SW =>
      read <= '0';
      write <= '1';
    WHEN LB TO LHU =>
      read <= '1';
      write <= '0';
    WHEN OTHERS =>
      read <= '0';
      write <= '0';
  END CASE;   
  CASE currFunc IS
    WHEN LB | LBU | SB =>
      WordSize <= "00";
    WHEN LH | LHU | SH =>
      WordSize <= "01";
    WHEN OTHERS =>
      WordSize <= "10";
  END CASE;     
  END PROCESS;  
        
END ARCHITECTURE Behavior;

