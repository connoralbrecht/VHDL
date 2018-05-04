--
-- VHDL Architecture my_project_lib.Pipeline.Mixed
--
-- Created:
--          by - conno.UNKNOWN (DESKTOP-TFKO3GP)
--          at - 14:25:34 04/22/2018
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY std;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE work.RV32I.all;
USE std.textio.all;
USE ieee.std_logic_textio.all;

ENTITY Pipeline IS 
  PORT( clock, reset : IN std_ulogic);

END ENTITY Pipeline;

--
ARCHITECTURE Mixed OF Pipeline IS
  CONSTANT x_wide : std_ulogic_vector(31 DOWNTO 0) := (others => 'X');
  SIGNAL LeftSig, RightSig, ExtraSig, DataA, DataB, DataIn, Addr, DataOut, MemDataOut, WBDataOut, MemAddressOut : std_ulogic_vector(31 DOWNTO 0); 
  SIGNAL FuncDE, FuncEM, FuncMWB :  RV32I_Op; 
  SIGNAL DestRegDE, DestRegEM, DestRegMWB, RS1, RS2, DestRegOut  : std_ulogic_vector(4 DOWNTO 0); 
  SIGNAL InstFD  : std_ulogic_vector(31 DOWNTO 0); 
  SIGNAL WS : std_ulogic_vector(1 DOWNTO 0);
  SIGNAL AddrExMem, AddressFetch, Jaddr  : std_ulogic_vector(31 DOWNTO 0); 
  SIGNAL DataExMem, DataMemWB, FetchData, MemDataIn, DataArbIn, DataArbOut  : std_ulogic_vector(31 DOWNTO 0); 
  SIGNAL FetchDelay, stallRF, stallMem, FRead, Jmp, RS1c, RS2c, RDc, MemDelay, readMem, writeMem, writeWB, mdelay, WriteSelOut, ReadSelOut  : std_ulogic;
BEGIN
    FetchStage  : ENTITY work.Fetch(Structural)
    PORT MAP(Jaddr => Jaddr, Mdata => FetchData, Address => AddressFetch, Inst => InstFD, Clock => Clock, Jmp => Jmp, Reset => reset, Delay => FetchDelay or StallRF, Read => FRead);
      
    DecodeStage : ENTITY work.DecPipe(Behavior)
    PORT MAP(Inst => InstFD, Address => AddressFetch, DataA => DataA, DataB => DataB, Left => LeftSig, Right => RightSig, Extra => ExtraSig, 
    DestReg => DestRegDE , Func => FuncDE, Clock => clock, Jmp => Jmp, stall => stallRF, RS1v => RS1c, RS2v => RS2c, RDv => RDc, RS1 => RS1, RS2 => RS2, reset => reset);
      
    ExecuteStage : ENTITY work.Execute(Behavior)
    PORT MAP(Data => DataExMem, Clock => clock, Jaddr => Jaddr, Jmp => Jmp, Address => AddrExMem, Left => LeftSig, Right => RightSig, 
    Extra => ExtraSig, DestRegIn => DestRegDE , DestRegOut => DestRegEM, FuncIn => FuncDE, FuncOut => FuncEM, stall => stallMem);
    
    MemoryStage  : ENTITY work.MemPipe(Behavior)
    PORT MAP(AddressIn => AddrExMem, DataExecuteIn => DataExMem, DataMemIn => MemDataIn, AddressOut => MemAddressOut, DataMemOut => MemDataOut, DataWriteBackOut => DataMemWB, 
    DestRegIn => DestRegEM, DestRegOut => DestRegMWB, FuncIn => FuncEM, FuncOut => FuncMWB, WordSize => WS, read => readMem, write => writeMem, stall => stallMem, Clock => clock, mdelay => MemDelay);
      
    WriteBackStage : ENTITY work.WriteBack(Behavior)
    PORT MAP(DataIn => DataMemWB, DataOut => WBDataOut, DestRegIn => DestRegMWB, DestRegOut => DestRegOut, FuncIn => FuncMWB, write => writeWB, Clock => clock);

    RegFile : ENTITY work.RegisterFile(Behavior) 
    PORT MAP(regAddrA => RS1, regAddrB => RS2, writeD => RDc, readA => RS1c, readB => RS2c, reset => reset, writeAddr => DestRegOut, reserveAddr => DestRegDE, DataOutA => DataA, 
    DataOutB => DataB, writeDataIn => WBDataOut, stall => stallRF, Clock => clock, writeWB => writeWB);    
      
         
    MemArb  : ENTITY work.Mem_Arb(Behavior)
    PORT MAP(FetchAddress => AddressFetch, MemAddress => MemAddressOut, DataMemIn => MemDataOut, DataIn => DataArbIn, AddressOut => Addr, FetchData => FetchData, DataMemOut => MemDataIn, 
    DataOut => DataArbOut, WordSizeIn => WS, FetchDelay => FetchDelay, MemDelay => MemDelay, WriteSelOut => WriteSelOut, FetchRead => FRead, DelayIn => mdelay, read => readMem, 
    write => writeMem, ReadSelOut => ReadSelOut);
   
    MemSys : ENTITY work.MemorySystem(Behavior)
    PORT MAP(Addr => Addr, DataIn => DataArbOut, clock => clock, we => WriteSelOut, re => ReadSelOut, mdelay => mdelay, DataOut => DataArbIn);


END ARCHITECTURE Mixed;

