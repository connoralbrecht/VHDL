--
-- VHDL Architecture my_project_lib.Mem_Arb_tb.test
--
-- Created:
--          by - conno.UNKNOWN (DESKTOP-TFKO3GP)
--          at - 07:27:57 04/ 9/2018
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_textio.all;
USE std.textio.all;
USE work.RV32I.all;

ENTITY Mem_Arb_tb IS
END ENTITY Mem_Arb_tb;


--
ARCHITECTURE test OF Mem_Arb_tb IS
  FILE test_vectors : text OPEN read_mode IS "Mem_Arb_Vecs.txt";
  SIGNAL FetchAddr, MemAddr, DataMemIn, DataIn : std_ulogic_vector(31 downto 0);
  SIGNAL AddrOut, FetchData, DataMemOut, DataOut, AddrOut_C, FetchData_C, DataMemOut_C, DataOut_C : std_ulogic_vector(31 downto 0);
  SIGNAL WordSizeIn : std_ulogic_vector(1 downto 0);
  SIGNAL WordSizeOut, WordSizeOut_C : std_ulogic_vector(1 downto 0);
  SIGNAL FetchDelay, MemDelay, WriteSelOut, FetchDelay_C, MemDelay_C, WriteSelOut_C : std_ulogic;
  SIGNAL FetchRead, DelayIn, Clock, read1, write : std_ulogic;
  SIGNAL vecno : NATURAL := 0;
BEGIN
  
  DUV : ENTITY work.Mem_Arb(Behavior)
    PORT MAP( FetchAddress => FetchAddr, MemAddress => MemAddr, DataMemIn=> DataMemIn, DataIn => DataIn, AddressOut=> AddrOut, FetchData => FetchData,
              DataMemOut => DataMemOut, DataOut => DataOut, read => read1, write=> write, WordSizeIn => WordSizeIn, WordSizeOut => WordSizeOut, FetchDelay => FetchDelay,
              MemDelay => MemDelay, WriteSelOut => WriteSelOut, FetchRead => FetchRead, DelayIn => DelayIn
            );
  
  Stim : Process
    VARIABLE L : LINE;
    VARIABLE FetchAddr_tb, MemAddr_tb, DataMemIn_tb, DataIn_tb : std_ulogic_vector(31 downto 0);
    VARIABLE AddrOut_tb, FetchData_tb, DataMemOut_tb, DataOut_tb : std_ulogic_vector(31 downto 0);
    VARIABLE WordSizeIn_tb : std_ulogic_vector(1 downto 0);
    VARIABLE WordSizeOut_tb : std_ulogic_vector(1 downto 0);
    VARIABLE FetchDelay_tb, MemDelay_tb, WriteSelOut_tb : std_ulogic;
    VARIABLE FetchRead_tb, DelayIn_tb, write_tb, read_tb : std_ulogic;
    Variable spaceVal : character;
  Begin
    Clock <= '0';
    wait for 40 ns;
    readline(test_vectors, L);
    WHILE NOT endfile(test_vectors) LOOP
      readline(test_vectors, L);
      
      hread(L, FetchAddr_tb);
      FetchAddr <= FetchAddr_tb;
      hread(L, MemAddr_tb);
      MemAddr <= MemAddr_tb;
      hread(L, DataMemIn_tb);
      DataMemIn <= DataMemIn_tb;
      hread(L, DataIn_tb);
      DataIn <= DataIn_tb;
      
      hread(L, AddrOut_tb);
      AddrOut_C <= AddrOut_tb;
      hread(L, FetchData_tb);
      FetchData_C <= FetchData_tb;
      hread(L, DataMemOut_tb);
      DataMemOut_C <= DataMemOut_tb;
      hread(L, DataOut_tb);
      DataOut_C <= DataOut_tb;
      
      read(L, read_tb);
      read1 <= read_tb;
      read(L, write_tb);
      write <= write_tb;
      
      read(L, WordSizeIn_tb);
      WordSizeIn <= WordSizeIn_tb;
      
      read(L, WordSizeOut_tb);
      WordSizeOut_C <= WordSizeOut_tb;
      
      read(L, FetchDelay_tb);
      FetchDelay_C <= FetchDelay_tb;
      read(L, MemDelay_tb);
      MemDelay_C <= MemDelay_tb;
      read(L, WriteSelOut_tb);
      WriteSelOut_C <= WriteSelOut_tb;
      
      read(L, FetchRead_tb);
      FetchRead <= FetchRead_tb;
      read(L, DelayIn_tb);
      DelayIn <= DelayIn_tb;
      
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
      ASSERT (AddrOut_C = AddrOut)
      REPORT "ERROR: Incorrect AddrOut for vector " & to_string(vecno)
      SEVERITY WARNING;
      ASSERT (FetchData_C = FetchData)
      REPORT "ERROR: Incorrect FetchData for vector " & to_string(vecno)
      SEVERITY WARNING;
      ASSERT (DataMemOut_C = DataMemOut)
      REPORT "ERROR: Incorrect DataMemOut for vector " & to_string(vecno)
      SEVERITY WARNING;
      ASSERT (DataOut_C = DataOut)
      REPORT "ERROR: Incorrect DataOut for vector " & to_string(vecno)
      SEVERITY WARNING;
      ASSERT (WordSizeOut_C = WordSizeOut)
      REPORT "ERROR: Incorrect WordSizeOut for vector " & to_string(vecno)
      SEVERITY WARNING;
      ASSERT (FetchDelay_C = FetchDelay)
      REPORT "ERROR: Incorrect FetchDelay for vector " & to_string(vecno)
      SEVERITY WARNING;
      ASSERT (MemDelay_C = MemDelay)
      REPORT "ERROR: Incorrect MemDelay for vector " & to_string(vecno)
      SEVERITY WARNING;
      ASSERT (WriteSelOut_C = WriteSelOut)
      REPORT "ERROR: Incorrect WriteSelOut for vector " & to_string(vecno)
      SEVERITY WARNING;
      vecno <= vecno + 1;
    END IF;
  END PROCESS;
END ARCHITECTURE test;



