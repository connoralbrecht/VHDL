--
-- VHDL Architecture my_project_lib.ALU.Behavior
--
-- Created:
--          by - conno.UNKNOWN (DESKTOP-TFKO3GP)
--          at - 16:47:44 03/25/2018
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE work.RV32I.all;

ENTITY ALU IS
  PORT( ALU : IN ALU_Op;
        shamt : IN std_ulogic_vector(4 DOWNTO 0);
        DataA, DataB  : IN std_ulogic_vector(31 DOWNTO 0);
        DataOut : OUT std_ulogic_vector(31 DOWNTO 0);
        DataOut_Zero  : OUT std_ulogic);
END ENTITY ALU;
--
ARCHITECTURE Behavior OF ALU IS
  CONSTANT long_zero : std_ulogic_vector(31 DOWNTO 0) := (others => '0');
  CONSTANT long_x : std_ulogic_vector(31 DOWNTO 0) := (others => 'X');
  SIGNAL DataOutTemp : std_ulogic_vector(31 DOWNTO 0);
BEGIN
  PROCESS(ALU, DataA, DataB, DataOutTemp, shamt) IS
  BEGIN
    CASE ALU IS
      WHEN aADD =>
        DataOutTemp <= std_ulogic_vector(SIGNED (DataA) + SIGNED (DataB));
      WHEN aSUB =>
        DataOutTemp <= std_ulogic_vector(SIGNED (DataA) - SIGNED (DataB));
      WHEN aAND =>
        DataOutTemp <= DataA AND DataB;
      WHEN aOR =>
        DataOutTemp <= DataA OR DataB;
      WHEN aXOR =>
        DataOutTemp <= DataA XOR DataB;
      WHEN aSL =>
        DataOutTemp <= std_ulogic_vector(shift_left(UNSIGNED(DataA), to_integer(UNSIGNED(shamt))));
      WHEN aSRL =>
        DataOutTemp <= std_ulogic_vector(shift_right(UNSIGNED(DataA), to_integer(UNSIGNED(shamt))));
      WHEN aSRA =>
        DataOutTemp <= std_ulogic_vector(shift_right(SIGNED(DataA), to_integer(UNSIGNED(shamt))));
      WHEN OTHERS =>
        DataOutTemp <= long_x;
    END CASE;
    IF DataOutTemp = long_zero THEN
      DataOut_Zero <= '1';
    ELSIF DataOutTemp = long_x THEN
      DataOut_Zero <= 'X';
    ELSE
      DataOut_Zero <= '0';
    END IF;
    DataOut <= DataOutTemp;
  END PROCESS;
END ARCHITECTURE Behavior;

