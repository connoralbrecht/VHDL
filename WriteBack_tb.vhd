--
-- VHDL Architecture my_project_lib.WriteBack_tb.test
--
-- Created:
--          by - conno.UNKNOWN (DESKTOP-TFKO3GP)
--          at - 07:28:50 04/ 9/2018
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_textio.all;
USE std.textio.all;
USE work.RV32I.all;

ENTITY WriteBack_tb IS
END ENTITY WriteBack_tb;

--

ARCHITECTURE test OF WriteBack_tb IS
  FILE test_vectors : text OPEN read_mode IS "WBTest.txt";
  SIGNAL FuncIn : RV32I_Op; 
  SIGNAL DestRegIn, DestRegOut, DestRegOut_C : std_ulogic_vector(4 DOWNTO 0);
  SIGNAL DataIn : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL DataOut, DataOut_C : std_ulogic_vector(31 DOWNTO 0);
  Signal write, write_C, Clock : std_ulogic;
  SIGNAL vecno : NATURAL := 0;
BEGIN

  DUV : ENTITY work.WriteBack(Behavior)
    PORT MAP (FuncIn => FuncIn, DestRegIn => DestRegIn, DestRegOut=> DestRegOut, DataIn => DataIn,
              DataOut => DataOut, write => write, Clock => Clock);
  
  Stim : Process
    VARIABLE L : LINE;
    Variable DataIn_tb, DataOut_tb : std_ulogic_vector(31 DOWNTO 0);
    Variable DestRegIn_tb, DestRegOut_tb : std_ulogic_vector(4 DOWNTO 0);
    Variable FuncIn_tb : Func_Name;
    Variable write_tb : std_ulogic;
    Variable dummy : character;
  Begin
    Clock <= '0';
    wait for 40 ns;
    readline(test_vectors, L);
    WHILE NOT endfile(test_vectors) LOOP
      readline(test_vectors, L);
      
      read(L, FuncIn_tb);
      FuncIn <= Ftype(FuncIn_tb);
      
      hread(L, DataIn_tb);
      DataIn <= DataIn_tb;
      
      hread(L, DataOut_tb);
      DataOut_C <= DataOut_tb;
      
      read(L, write_tb);
      write_C <= write_tb;
      
      read(L, DestRegIn_tb);
      DestRegIn <= DestRegIn_tb;
      
      read(L, DestRegOut_tb);
      DestRegOut_C <= DestRegOut_tb;
      
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
      ASSERT (DataOut_C = DataOut)
      REPORT "ERROR: Incorrect DataOut for vector " & to_string(vecno)
      SEVERITY WARNING;
      ASSERT (write_C = write)
      REPORT "ERROR: Incorrect write for vector " & to_string(vecno)
      SEVERITY WARNING;
      ASSERT (DestRegOut_C = DestRegOut)
      REPORT "ERROR: Incorrect DestRegOut for vector " & to_string(vecno)
      SEVERITY WARNING;
      vecno <= vecno + 1;
    END IF;
  END PROCESS;
END ARCHITECTURE test;

