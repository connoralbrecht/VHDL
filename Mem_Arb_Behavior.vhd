--
-- VHDL Architecture my_project_lib.Mem_Arb.Behavior
--
-- Created:
--          by - conno.UNKNOWN (DESKTOP-TFKO3GP)
--          at - 16:01:23 04/ 8/2018
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY Mem_Arb IS
PORT( FetchAddress, MemAddress, DataMemIn, DataIn : IN std_ulogic_vector(31 downto 0);
      AddressOut, FetchData, DataMemOut, DataOut : OUT std_ulogic_vector(31 downto 0);
      WordSizeIn : IN std_ulogic_vector(1 downto 0);
      WordSizeOut : OUT std_ulogic_vector(1 downto 0);
      FetchDelay, MemDelay, WriteSelOut : OUT std_ulogic;
      FetchRead, DelayIn, read, write : IN std_ulogic);
END ENTITY Mem_Arb;

--
ARCHITECTURE Behavior OF Mem_Arb IS
  SIGNAL Mem_Op : std_ulogic;
  CONSTANT x_wide : std_ulogic_vector(31 DOWNTO 0) := (others => 'X');
BEGIN
  Mem_Op <= read OR write;
  PROCESS(Mem_Op, FetchAddress, MemAddress, DataMemIn, DataIn, WordSizeIn, FetchRead, DelayIn, read, write) IS
  BEGIN
    IF Mem_Op = '1' THEN
      AddressOut <= MemAddress;
      FetchData <= x_wide;
      DataMemOut <= DataIn;
      DataOut <= DataMemIn;
      WordSizeOut <= WordSizeIn;
      FetchDelay <= FetchRead;
      MemDelay <= DelayIn;
      IF write = '1' THEN
        WriteSelOut <= '1';
      ELSE
        WriteSelOut <= '0';
      END IF;
    ELSE
      AddressOut <= FetchAddress;
      FetchData <= DataIn;
      DataMemOut <= x_wide;
      DataOut <= x_wide;
      WordSizeOut <= "10";
      FetchDelay <= DelayIn;
      MemDelay <= '0';
      WriteSelOut <= '0';
    END IF; 
  END PROCESS;
END ARCHITECTURE Behavior;


