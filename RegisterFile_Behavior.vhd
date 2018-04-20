--
-- VHDL Architecture my_project_lib.RegisterFile.Behavior
--
-- Created:
--          by - conno.UNKNOWN (DESKTOP-TFKO3GP)
--          at - 10:13:06 04/16/2018
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE work.RV32I.all;

ENTITY RegisterFile IS
  PORT( regAddrA, regAddrB, writeAddr, reserveAddr : IN std_ulogic_vector(4 DOWNTO 0);
        DataOutA, DataOutB : OUT std_ulogic_vector(31 DOWNTO 0);
        writeDataIn : IN std_ulogic_vector(31 DOWNTO 0);
        stall : OUT std_ulogic;
        Clock, reset, writeWB, writeD, readA, readB : IN std_ulogic);
END ENTITY RegisterFile;

--
ARCHITECTURE Behavior OF RegisterFile IS
  TYPE regFileArray IS ARRAY(0 to 31) OF STD_ULOGIC_VECTOR(31 DOWNTO 0);
  CONSTANT x_wide : std_ulogic_vector(31 DOWNTO 0) := (others => 'X');
  CONSTANT zero_wide : std_ulogic_vector(31 DOWNTO 0) := (others => '0');
  SIGNAL registers : regFileArray;
  SIGNAL regReserved  : STD_ULOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL enable : std_ulogic;
  SIGNAL RAWcheckA, RAWcheckB : std_ulogic;
  
BEGIN
  RAWcheckA <= (writeWB AND readA);
  RAWcheckB <= (writeWB AND readB);
  enable <= (writeWB OR readA OR readB);
  PROCESS(Clock, enable, reset, regReserved) IS
  BEGIN
    IF reset = '1' THEN
        registers <= (others => (others=>'0')); -- zero out each reg for reset
        DataOutA <= x_wide;
        DataOutB <= x_wide;
        stall <= '0';
    ELSIF(rising_edge(Clock) and enable = '1') THEN

          IF readA = '1' AND regReserved(to_integer(unsigned(regAddrA))) /= '1' THEN
            DataOutA <= registers(to_integer(unsigned(regAddrA))); 
            stall <= '0';
          ELSIF readA = '1' AND regReserved(to_integer(unsigned(regAddrA))) = '1' THEN
            stall <= '1';
            DataOutA <= x_wide;
          ELSE
            DataOutA <= x_wide;
          END IF;
  
          
          IF readB = '1' AND regReserved(to_integer(unsigned(regAddrB))) /= '1' THEN
            DataOutB <= registers(to_integer(unsigned(regAddrB))); --read data from corresponding reg(regNum) in regfile array
            stall <= '0';         
          ELSIF readB = '1' AND regReserved(to_integer(unsigned(regAddrB))) = '1' THEN
            stall <= '1';            
            DataOutB <= x_wide;
          ELSE
            DataOutB <= x_wide;
          END IF;
  
          
          IF writeWB = '1' AND writeAddr /= "00000"  THEN
            registers(to_integer(unsigned(writeAddr))) <= writeDataIn; --write input data to corresponding regin reg file                     
          END IF; --write if
          
          
          IF RAWcheckA = '1' AND writeAddr = regAddrA THEN
              DataOutA <= writeDataIn;
          END IF;
          IF RAWcheckB = '1' AND writeAddr = regAddrB THEN
              DataOutB <= writeDataIn;
          END IF;          
    ELSIF(rising_edge(Clock) and enable = '0') THEN
      DataOutA <= x_wide;
      DataOutB <= x_wide;
    END IF; --clock if
  END PROCESS;

  
  --RESERVE or FREE registers (decides whether to stall)    
    PROCESS(writeWB, writeD, writeAddr, reserveAddr, reset, Clock) IS
    BEGIN
      IF reset = '1' THEN
        regReserved <= zero_wide;
      END IF;
      
      IF writeWB = '1' THEN
        regReserved(to_integer(unsigned(writeAddr))) <= '0';
      END IF;
      IF writeD = '1'  THEN
        regReserved(to_integer(unsigned(reserveAddr))) <= '1';
      END IF;
    END PROCESS;
        
END ARCHITECTURE Behavior;

