--
-- VHDL Architecture my_project_lib.RegisterFile_tb.test
--
-- Created:
--          by - conno.UNKNOWN (DESKTOP-TFKO3GP)
--          at - 10:15:49 04/16/2018
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_textio.all;
USE std.textio.all;
USE work.RV32I.all;

ENTITY RegisterFile_tb IS
END ENTITY RegisterFile_tb;


--
ARCHITECTURE test OF RegisterFile_tb IS 
  FILE RegVecs : text OPEN read_mode IS
      "RegVecs.txt"; 
  SIGNAL Clock, reset, writeWB, writeD, readA, readB, stall, stall_C : std_ulogic;
  SIGNAL regAddrA, regAddrB, writeAddr, reserveAddr : std_ulogic_vector(4 DOWNTO 0);
  SIGNAL DataOutA, DataOutB, DataOutA_C, DataOutB_C : std_ulogic_vector(31 DOWNTO 0); 
  SIGNAL writeDataIn : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL vecno : NATURAL := 0;

BEGIN
  DUV : ENTITY work.RegisterFile(Behavior)
    PORT MAP(reserveAddr => reserveAddr, regAddrA => regAddrA, regAddrB => regAddrB, writeAddr => writeAddr, DataOutA => DataOutA, 
    DataOutB => DataOutB, writeDataIn => writeDataIn, reset => reset, writeWB => writeWB, 
    writeD => writeD, stall =>stall, readA => readA, readB => readB, Clock => Clock);

              
        
  Stim : PROCESS
    VARIABLE L : LINE;
    VARIABLE reset_tb, writeWB_tb, writeD_tb, readA_tb, readB_tb, stall_tb : std_ulogic;
    VARIABLE regAddrA_tb, regAddrB_tb, writeAddr_tb, reserveAddr_tb : std_ulogic_vector(4 DOWNTO 0);
    VARIABLE DataOutA_tb, DataOutB_tb : std_ulogic_vector(31 DOWNTO 0); 
    VARIABLE writeDataIn_tb : std_ulogic_vector(31 DOWNTO 0);
    VARIABLE dummy  : character; 
  BEGIN
    Clock <= '0';
    wait for 10 ns;
    readline(RegVecs, L);
    WHILE NOT endfile(RegVecs) LOOP
      readline(RegVecs, L);      
      --inputs     
      hread(L, writeDataIn_tb);
      writeDataIn <= writeDataIn_tb;
      
      read(L, regAddrA_tb);
      regAddrA <= regAddrA_tb;
      read(L, regAddrB_tb);
      regAddrB <= regAddrB_tb;
      read(L, writeAddr_tb);
      writeAddr <= writeAddr_tb;
      read(L, reserveAddr_tb);
      reserveAddr <= reserveAddr_tb;
            
      read(L, reset_tb);
      reset <= reset_tb; 
      read(L, writeWB_tb);
      writeWB <= writeWB_tb;
      read(L, writeD_tb);
      writeD <= writeD_tb;
      read(L, readA_tb);
      readA <= readA_tb; 
      read(L, readB_tb);
      readB <= readB_tb;
                  
      --outputs          
      hread(L, DataOutA_tb);
      DataOutA_C <= DataOutA_tb;      
      hread(L, DataOutB_tb);
      DataOutB_C <= DataOutB_tb;
      read(L, stall_tb);
      stall_C <= stall_tb;              

      wait for 10 ns;
      Clock <= '1';
      wait for 50 ns;
      Clock <= '0';
      wait for 40 ns;
    END LOOP;
    report "End of Testbench.";
    std.env.finish;
  END PROCESS;

  Check : PROCESS(Clock)
  BEGIN
    IF(falling_edge(Clock)) THEN
      ASSERT DataOutA_C = DataOutA
        REPORT "ERROR DataOutA: Incorrect output for vector " & to_string(vecno)
        SEVERITY WARNING;
      ASSERT DataOutB_C = DataOutB
        REPORT "ERROR DataOutB: Incorrect output for vector " & to_string(vecno)
        SEVERITY WARNING;
      ASSERT stall_C = stall
        REPORT "ERROR stall: Incorrect output for vector " & to_string(vecno)
        SEVERITY WARNING;
        
      vecno <= vecno + 1;
    END IF;
  END PROCESS; 
END ARCHITECTURE test;

