--
-- VHDL Architecture my_project_lib.fetch_tb.test
--
-- Created:
--          by - conno.UNKNOWN (DESKTOP-TFKO3GP)
--          at - 15:22:43 02/ 9/2018
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE std.textio.all;

ENTITY fetch_tb IS
END ENTITY fetch_tb;

--
ARCHITECTURE test OF fetch_tb IS
  FILE fetch_vectors : text OPEN read_mode IS
      "fetch_vectors.txt";
  SIGNAL Clock, Jmp, Reset, Delay : std_ulogic;
  SIGNAL Jaddr, Mdata : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL Address, Inst, AddressV, InstV : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL Read1, ReadV : std_ulogic;
  
  SIGNAL vecno : NATURAL := 0;

  CONSTANT long_zero : std_ulogic_vector(31 DOWNTO 0) := (others => '0');
  CONSTANT NOP : std_ulogic_vector(31 DOWNTO 0) := "00000000000000000000000000010011";
  CONSTANT CLK_PERIOD : time := 50 ns;
BEGIN
  DUV : ENTITY work.Fetch(Structural)
    GENERIC MAP(size=>32)
    PORT MAP(Jaddr => Jaddr, Mdata => Mdata, Address => Address, Inst => Inst, Reset => Reset, Read => Read1, Jmp => Jmp, Delay => Delay, Clock => Clock);
  Stim : PROCESS
    VARIABLE L : LINE;
    VARIABLE JmpVal, ResetVal, DelayVal : std_ulogic;
    VARIABLE JaddrVal, MdataVal : std_ulogic_vector(31 DOWNTO 0);
    VARIABLE AddressVal, InstVal : std_ulogic_vector(31 DOWNTO 0);
    VARIABLE ReadVal : std_ulogic;    
  BEGIN    
    Clock <= '0';
    wait for 40 ns;
    readline(fetch_vectors, L);
    WHILE NOT endfile(fetch_vectors) LOOP
      readline(fetch_vectors, L);
      read(L, JmpVal);
      Jmp <= JmpVal;
      read(L, ResetVal);
      Reset <= ResetVal;
      read(L, DelayVal);
      Delay <= DelayVal;
      read(L, ReadVal);
      ReadV <= ReadVal;
      read(L, MdataVal);
      Mdata <= MdataVal;
      read(L, JaddrVal);
      Jaddr <= JaddrVal;
      read(L, AddressVal);
      AddressV <= AddressVal;
      read(L, InstVal);
      InstV <= InstVal;
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
      ASSERT ReadV = Read1
        REPORT "ERROR read: Incorrect output for vector " & to_string(vecno)
        SEVERITY WARNING;
      ASSERT AddressV = Address
        REPORT "ERROR Addr: Incorrect output for vector " & to_string(vecno)
        SEVERITY WARNING;
      vecno <= vecno + 1;
    END IF;
    IF(rising_edge(Clock)) THEN
      ASSERT InstV = Inst
        REPORT "ERROR inst: Incorrect output for vector " & to_string(vecno)
        SEVERITY WARNING;
      vecno <= vecno + 1;
    END IF;
  END PROCESS;
END ARCHITECTURE test;

