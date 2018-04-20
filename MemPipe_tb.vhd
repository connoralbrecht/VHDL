--
-- VHDL Architecture my_project_lib.MemPipe_tb.test
--
-- Created:
--          by - conno.UNKNOWN (DESKTOP-TFKO3GP)
--          at - 07:28:26 04/ 9/2018
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_textio.all;
USE std.textio.all;
USE work.RV32I.all;

ENTITY MemPipe_tb IS
END ENTITY MemPipe_tb;

--
ARCHITECTURE test OF MemPipe_tb IS
  FILE test_vectors : text OPEN read_mode IS "MemTest.txt";
  SIGNAL FuncIn, FuncOut, FuncOut_C : RV32I_Op; 
  SIGNAL AddressIn, DataExecuteIn, DataMemIn : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL AddressOut, DataMemOut, DataWriteBackOut, AddressOut_C, DataMemOut_C, DataWriteBackOut_C : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL WordSize, WordSize_C: std_ulogic_vector(1 downto 0);
  Signal mdelay, Clock, stall, stall_C, read1, write, read1_C, write_C : std_ulogic;
  SIGNAL vecno : NATURAL := 0;
BEGIN
      
  DUV : ENTITY work.MemPipe(Behavior)
    PORT MAP (FuncIn => FuncIn, FuncOut => FuncOut, DestRegIn => "10011", AddressIn => AddressIn, DataExecuteIn => DataExecuteIn, DataMemIn => DataMemIn,
              AddressOut => AddressOut, DataMemOut => DataMemOut, DataWriteBackOut => DataWriteBackOut,
              read => read1, write=> write, WordSize => WordSize, mdelay=> mdelay, stall=> stall, Clock => Clock);
  
  Stim : Process
    VARIABLE L : LINE;
    Variable AddressIn_tb, DataExecuteIn_tb, DataMemIn_tb, AddressOut_tb, DataMemOut_tb, DataWriteBackOut_tb : std_ulogic_vector(31 DOWNTO 0);
    Variable FuncIn_tb, FuncOut_tb : Func_Name;
    Variable WordSize_tb : std_ulogic_vector(1 downto 0);
    Variable mdelay_tb, stall_tb, read1_tb, write_tb: std_ulogic;
    Variable dummy : character;
  Begin
    Clock <= '0';
    wait for 40 ns;
    readline(test_vectors, L);
    WHILE NOT endfile(test_vectors) LOOP
      readline(test_vectors, L);
      
      read(L, FuncIn_tb);
      FuncIn <= Ftype(FuncIn_tb);
      
      read(L, dummy);
      
      read(L, FuncOut_tb);
      FuncOut_C <= Ftype(FuncOut_tb);
      
      hread(L, AddressIn_tb);
      AddressIn <= AddressIn_tb;
      
      hread(L, DataExecuteIn_tb);
      DataExecuteIn <= DataExecuteIn_tb;
      
      hread(L, DataMemIn_tb);
      DataMemIn <= DataMemIn_tb;
      
      hread(L, AddressOut_tb);
      AddressOut_C <= AddressOut_tb;
      
      hread(L, DataMemOut_tb);
      DataMemOut_C <= DataMemOut_tb;
      
      hread(L, DataWriteBackOut_tb);
      DataWriteBackOut_C <= DataWriteBackOut_tb;
      
      read(L, read1_tb);
      read1_C <= read1_tb;
      
      read(L, write_tb);
      write_C <= write_tb;
      
      read(L, WordSize_tb);
      WordSize_C <= WordSize_tb;
      
      read(L, mdelay_tb);
      mdelay <= mdelay_tb;
      
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
    IF (falling_edge(Clock)) THEN
      ASSERT (FuncOut_C = FuncOut)
      REPORT "ERROR: Incorrect FuncOut for vector " & to_string(vecno)
      SEVERITY WARNING;
      ASSERT (AddressOut_C = AddressOut)
      REPORT "ERROR: Incorrect AddressOut for vector " & to_string(vecno)
      SEVERITY WARNING;
      ASSERT (DataMemOut_C = DataMemOut)
      REPORT "ERROR: Incorrect DataMemOut for vector " & to_string(vecno)
      SEVERITY WARNING;
      ASSERT (DataWriteBackOut_C = DataWriteBackOut)
      REPORT "ERROR: Incorrect DataWriteBackOut for vector " & to_string(vecno)
      SEVERITY WARNING;
      ASSERT (read1_C = read1)
      REPORT "ERROR: Incorrect read for vector " & to_string(vecno)
      SEVERITY WARNING;
      ASSERT (write_C = write)
      REPORT "ERROR: Incorrect write for vector " & to_string(vecno)
      SEVERITY WARNING;
      ASSERT (WordSize_C = WordSize)
      REPORT "ERROR: Incorrect WordSize for vector " & to_string(vecno)
      SEVERITY WARNING;
      ASSERT (stall_C = stall)
      REPORT "ERROR: Incorrect stall for vector " & to_string(vecno)
      SEVERITY WARNING;
      vecno <= vecno + 1;
    END IF;
  END PROCESS;
END ARCHITECTURE test;


