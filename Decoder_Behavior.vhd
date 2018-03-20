--
-- VHDL Architecture my_project_lib.Decoder.Behavior
--
-- Created:
--          by - conno.UNKNOWN (DESKTOP-TFKO3GP)
--          at - 16:16:05 02/21/2018
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE work.RV32I.all;

ENTITY Decoder IS
  PORT( Inst : IN std_ulogic_vector(31 DOWNTO 0);
       -- C   :  IN std_ulogic;
        Func : OUT RV32I_Op; --Refer to package for enumeration type def
        I_type  : OUT InsType;
        RS1, RS2, RD : OUT std_ulogic_vector(4 DOWNTO 0); --Reg IDs
        RS1v, RS2v, RDv : OUT std_ulogic; --Valid indicators for Reg IDs
        Imm : OUT std_ulogic_vector(31 DOWNTO 0)); --Imm
END ENTITY Decoder;

--
ARCHITECTURE Behavior OF Decoder IS
  CONSTANT long_zero : std_ulogic_vector(31 DOWNTO 0) := (others => '0');
  CONSTANT long_x : std_ulogic_vector(31 DOWNTO 0) := (others => 'X');
 -- SIGNAL I_type : InsType;
  SIGNAL OpCode : std_ulogic_vector(4 DOWNTO 0);
  SIGNAL check_bits  : std_ulogic_vector(1 DOWNTO 0);
  SIGNAL sign_bit  : std_ulogic;
  SIGNAL Func_3 : std_ulogic_vector(2 DOWNTO 0);
  SIGNAL Func_7 : std_ulogic_vector(6 DOWNTO 0);
  SIGNAL I_Load : std_ulogic;
  SIGNAL NOP_check : std_ulogic;
BEGIN
  PROCESS(Inst) IS
  BEGIN
--    Imm <= (others => '0');
    sign_bit <= Inst(31);
    check_bits <= Inst(1 DOWNTO 0);
    Func_7 <= Inst(31 DOWNTO 25);
    RS2 <= Inst(24 DOWNTO 20);
    RS1 <= Inst(19 DOWNTO 15);
    Func_3 <= Inst(14 DOWNTO 12);
    RD <= Inst(11 DOWNTO 7);
    OpCode <= Inst(6 DOWNTO 2);
    IF Inst(31 DOWNTO 0) = NOP_inst THEN
      NOP_check <= '1';
    END IF;
  END PROCESS;
  PROCESS(OpCode, Func_3, Func_7, RD, RS1, RS2, check_bits) IS
  BEGIN
    IF check_bits = "11" THEN
     CASE OpCode IS
        WHEN "01101" =>  --LUI
          Func <= LUI;
          I_type <= U;
          RS1v <= '0';
          RS2v <= '0';
          RDv <= '1';
          Imm(31) <= Inst(31);
          Imm(30 DOWNTO 20) <= Inst(30 DOWNTO 20);
          Imm(19 DOWNTO 12) <= Inst( 19 DOWNTO 12);
          Imm(11 DOWNTO 0) <= (others => '0');  --      
        WHEN "00101" =>  --AUIPC
          Func <= AUIPC;
          I_type <= U;
          RS1v <= '0';
          RS2v <= '0';
          RDv <= '1';
          Imm(31) <= Inst(31);
          Imm(30 DOWNTO 20) <= Inst(30 DOWNTO 20);
          Imm(19 DOWNTO 12) <= Inst(19 DOWNTO 12);
          Imm(11 DOWNTO 0) <= (others => '0'); --
        WHEN "11011" =>  --JAL
          Func <= JAL;
          I_type <= UJ;
          RS1v <= '0';
          RS2v <= '0';
          RDv <= '1';
          Imm(31 DOWNTO 20) <= (others => sign_bit);
          Imm(19 DOWNTO 12) <= Inst(19 DOWNTO 12);
          Imm(11) <= Inst(20);
          Imm(10 DOWNTO 5) <= Inst(30 DOWNTO 25); 
          Imm(4 DOWNTO 1) <= Inst(24 DOWNTO 21);           
          Imm(0) <= '0';
        WHEN "11001" =>  --JALR
          Func <= JALR;
          I_type <= I;
          RS1v <= '1';
          RS2v <= '0';
          RDv <= '1';
          Imm(31 DOWNTO 11) <= (others => sign_bit);
          Imm(10 DOWNTO 5) <= Inst(30 DOWNTO 25); 
          Imm(4 DOWNTO 1) <= Inst(24 DOWNTO 21);           
          Imm(0) <= Inst(20);
        WHEN "11000" =>  --BRANCH
          I_type <= SB;
          RS1v <= '1';
          RS2v <= '1';
          RDv <= '0';
          CASE Func_3 IS
            WHEN "000" =>
              Func <= BEQ;
            WHEN "001" =>
              Func <= BNE;
            WHEN "100" =>
              Func <= BLT;
            WHEN "101" =>
              Func <= BGE;
            WHEN "110" =>
              Func <= BLTU;
            WHEN "111" =>
              Func <= BGEU;
            WHEN OTHERS =>
              Func <= BAD;
          END CASE;              
          Imm(31 DOWNTO 12) <= (others => sign_bit);
          Imm(11) <= Inst(7);
          Imm(10 DOWNTO 5) <= Inst(30 DOWNTO 25); 
          Imm(4 DOWNTO 1) <= Inst(11 DOWNTO 8);           
          Imm(0) <= '0';
        WHEN "00000" =>  --LOAD
          I_type <= I;
          CASE Func_3 IS
            WHEN "000" =>
              Func <= LB;
            WHEN "001" =>
              Func <= LH;
            WHEN "010" =>
              Func <= LW;
            WHEN "100" =>
              Func <= LBU;
            WHEN "101" =>
                Func <= LHU;
            WHEN OTHERS =>
              Func <= BAD;
          END CASE;
          RS1v <= '1';
          RS2v <= '0';
          RDv <= '1';
          Imm(31 DOWNTO 11) <= (others => sign_bit);
          Imm(10 DOWNTO 5) <= Inst(30 DOWNTO 25); 
          Imm(4 DOWNTO 1) <= Inst(24 DOWNTO 21);           
          Imm(0) <= Inst(20);
        WHEN "01000" =>  --STORE
          I_type <= S;
          RS1v <= '1';
          RS2v <= '1';
          RDv <= '0';
          CASE Func_3 IS
            WHEN "000" =>
              Func <= SB;
            WHEN "001" =>
              Func <= SH;
            WHEN "010" =>
              Func <= SW;
            WHEN OTHERS =>
              Func <= BAD;
          END CASE;
          Imm(31 DOWNTO 11) <= (others => sign_bit);
          Imm(10 DOWNTO 5) <= Inst(30 DOWNTO 25); 
          Imm(4 DOWNTO 1) <= Inst(11 DOWNTO 8);           
          Imm(0) <= Inst(7);
        WHEN "00100" =>  --ALUI
          IF NOP_check = '1' THEN
            Func <= NOP;
            RS1v <= '0';
            RS2v <= '0';
            RDv <= '0';
          ELSIF Func_3 = "001" THEN 
            I_type <= R;
            RS1v <= '1';
            RS2v <= '0';
            RDv <= '1';
            Func <= SLLI;
            Imm(31 DOWNTO 0) <= (others => '0');
          ELSIF Func_3 = "101" THEN
            I_type <= R;
            RS1v <= '1';
            RS2v <= '0';
            RDv <= '1'; 
            Imm(31 DOWNTO 0) <= (others => '0');           
            IF Func_7 = "0000000" THEN
              Func <= SRLI;            
            ELSE
              Func <= SRAI;
            END IF;           
          ELSE
            I_type <= I;
            CASE Func_3 IS
              WHEN "000" =>
                Func <= ADDI;
              WHEN "010" =>
                Func <= SLTI;
              WHEN "011" =>
                Func <= SLTIU;
              WHEN "100" =>
                Func <= XORI;
              WHEN "110" =>
                Func <= ORI;
              WHEN "111" =>
                Func <= ANDI;
              WHEN OTHERS =>
                Func <= BAD;
            END CASE;  
            RS1v <= '1';
            RS2v <= '0';
            RDv <= '1';
            Imm(31 DOWNTO 11) <= (others => sign_bit);
            Imm(10 DOWNTO 5) <= Inst(30 DOWNTO 25); 
            Imm(4 DOWNTO 1) <= Inst(24 DOWNTO 21);           
            Imm(0) <= Inst(20);
          END IF;
        WHEN "01100" =>  --ALU
          I_type <= R;
          RS1v <= '1';
          RS2v <= '1';
          RDv <= '1';
          IF Func_3 = "000" AND Func_7 = "0000000" THEN
            Func <= ADDr;
          ELSIF Func_3 = "000" AND Func_7 = "0100000" THEN
            Func <= SUBr;
          ELSIF Func_3 = "101" AND Func_7 = "0100000" THEN
            Func <= SRAr;       
          ELSIF Func_3 = "101" AND Func_7 = "0000000" THEN
            Func <= SRLr;
          ELSE       
            CASE Func_3 IS
              WHEN "001" =>
                Func <= SLLr;
              WHEN "010" =>
                Func <= SLTr;
              WHEN "011" =>
                Func <= SLTUr;
              WHEN "100" =>
                Func <= XORr;
              WHEN "110" =>
                Func <= ORr;
              WHEN "111" =>
                Func <= ANDr;
              WHEN OTHERS =>
                Func <= BAD;
            END CASE;
          END IF;            
          Imm(31 DOWNTO 0) <= (others => '0'); 
        WHEN OTHERS =>
          Func <= BAD;
          RS1v <= '0';
          RS2v <= '0';
          RDv <= '0';      
     END CASE;
    ELSE
      Func <= BAD;
      RS1v <= '0';
      RS2v <= '0';
      RDv <= '0';
    END IF; 
  END PROCESS;
END ARCHITECTURE Behavior;

