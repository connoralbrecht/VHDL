--
-- VHDL Architecture my_project_lib.Execute_tb.test
--
-- Created:
--          by - conno.UNKNOWN (DESKTOP-TFKO3GP)
--          at - 12:41:40 04/ 1/2018
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE std.textio.all;
USE ieee.std_logic_textio.all;
USE work.RV32I.all;

ENTITY Execute_tb IS
END ENTITY Execute_tb;

--
ARCHITECTURE test OF Execute_tb IS 
  FILE ExecuteVecs : text OPEN read_mode IS
      "exec_vec.txt"; 
  SIGNAL Clock, Jmp, Jmp_C : std_ulogic;
  SIGNAL Left, Right, Extra : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL Jaddr, Jaddr_C, Address, Address_C, Data, Data_C : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL FuncIn : RV32I_Op; 
  SIGNAL DestRegIn : std_ulogic_vector(4 DOWNTO 0);
  SIGNAL vecno : NATURAL := 0;

BEGIN
  DUV : ENTITY work.Execute(Behavior)
    PORT MAP(Jmp=> Jmp, Jaddr => Jaddr, Right => Right, Left => Left, Extra => Extra, DestRegIn => "00110", Address => Address, Data => Data, FuncIn => FuncIn, Clock => Clock);
  Stim : PROCESS
    VARIABLE L : LINE;
    VARIABLE Left_tb, Right_tb, Extra_tb, Extra2_tb : std_ulogic_vector(31 DOWNTO 0);
    VARIABLE Jaddr_tb, Address_tb, Data_tb : std_ulogic_vector(31 DOWNTO 0);
    VARIABLE DestRegIn_tb : std_ulogic_vector(4 DOWNTO 0);
    VARIABLE Jmp_tb : std_ulogic;
    VARIABLE FuncIn_tb : Func_Name; 
    VARIABLE dummy  : character; 
  BEGIN
    Clock <= '0';
    wait for 10 ns;
    readline(ExecuteVecs, L);
    WHILE NOT endfile(ExecuteVecs) LOOP
      readline(ExecuteVecs, L);      
      --inputs
      --read(L, dummy);
      read(L, FuncIn_tb);
      FuncIn <= Ftype(FuncIn_tb);      
      hread(L, Left_tb);
      Left <= Left_tb;            
      hread(L, Right_tb);
      Right <= Right_tb;                  
      hread(L, Extra_tb);
      Extra <= Extra_tb;      
            
      --outputs          
      hread(L, Data_tb);
      Data_C <= Data_tb;      
      read(L, Jmp_tb);
      Jmp_C <= Jmp_tb;              
      hread(L, Jaddr_tb);
      Jaddr_C <= Jaddr_tb; 
      hread(L, Address_tb);
      Address_C <= Address_tb;                 
              
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
      ASSERT Data_C = Data
        REPORT "ERROR Data: Incorrect output for vector " & to_string(vecno)
        SEVERITY WARNING;
      ASSERT Jmp_C = Jmp
        REPORT "ERROR Jmp: Incorrect output for vector " & to_string(vecno)
        SEVERITY WARNING;
      ASSERT Jaddr_C = Jaddr
        REPORT "ERROR Jaddr: Incorrect output for vector " & to_string(vecno)
        SEVERITY WARNING;
      ASSERT Address_C = Address
        REPORT "ERROR Address: Incorrect output for vector " & to_string(vecno)
        SEVERITY WARNING;
      vecno <= vecno + 1;
    END IF;
  END PROCESS; 
END ARCHITECTURE test;

