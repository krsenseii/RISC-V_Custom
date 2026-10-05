----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.05.2026 19:45:24
-- Design Name: 
-- Module Name: PreDecode - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PreDecode is
    Port (
        Instruction : in  std_logic_vector(31 downto 0);

        Opcode      : out std_logic_vector(6 downto 0);
        Funct3      : out std_logic_vector(2 downto 0);
        Funct7      : out std_logic_vector(6 downto 0);

        Rd          : out std_logic_vector(4 downto 0);
        Rs1         : out std_logic_vector(4 downto 0);
        Rs2         : out std_logic_vector(4 downto 0);

        -- 000:S, 001:I, 010:B, 011:J, 100:U, 101:R, 111:Others
        TypeSel     : out std_logic_vector(2 downto 0);

        -- codificación instrucciones
        ICode       : out std_logic_vector(3 downto 0)
    );
end PreDecode;

architecture Behavioral of PreDecode is
    signal op : std_logic_vector(6 downto 0);
    signal f3 : std_logic_vector(2 downto 0);
    signal f7 : std_logic_vector(6 downto 0);
begin

    op <= Instruction(6 downto 0);
    f3 <= Instruction(14 downto 12);
    f7 <= Instruction(31 downto 25);

    Opcode <= op;
    Funct3 <= f3;
    Funct7 <= f7;

    Rd  <= Instruction(11 downto 7);
    Rs1 <= Instruction(19 downto 15);
    Rs2 <= Instruction(24 downto 20);

    process(op, f3, f7, Instruction)
    begin
        TypeSel <= "111";
        ICode   <= "1111";

        case op is
            -- R-type: ADD, SUB, AND, OR, XOR, SLL, SRL, SRA, SLT, SLTU
            when "0110011" =>
                TypeSel <= "101";
                case f3 is
                    when "000" =>
                        if f7 = "0000000" then ICode <= "0000"; -- ADD
                        elsif f7 = "0100000" then ICode <= "0001"; -- SUB
                        end if;
                    when "111" => ICode <= "0010"; -- AND
                    when "110" => ICode <= "0011"; -- OR
                    when "100" => ICode <= "0100"; -- XOR
                    when "001" => ICode <= "0101"; -- SLL
                    when "101" =>
                        if f7 = "0000000" then ICode <= "0110"; -- SRL
                        elsif f7 = "0100000" then ICode <= "0111"; -- SRA
                        end if;
                    when "010" => ICode <= "1000"; -- SLT
                    when "011" => ICode <= "1001"; -- SLTU
                    when others => null;
                end case;

            -- I-type: ALU-Imm, LOADS y JALR
            when "0010011" | "0000011" | "1100111" =>
                TypeSel <= "001";
                if op = "1100111" then 
                    ICode <= "1110"; -- JALR
                elsif op = "0000011" then -- LOADS
                    case f3 is
                        when "000" => ICode <= "1001"; -- LB
                        when "001" => ICode <= "1010"; -- LH
                        when "010" => ICode <= "1011"; -- LW
                        when "100" => ICode <= "1100"; -- LBU
                        when "101" => ICode <= "1101"; -- LHU
                        when others => null;
                    end case;
                else -- ALU Inmediata
                    case f3 is
                        when "000" => ICode <= "0000"; -- ADDI
                        when "111" => ICode <= "0001"; -- ANDI
                        when "110" => ICode <= "0010"; -- ORI
                        when "100" => ICode <= "0011"; -- XORI
                        when "001" => ICode <= "0100"; -- SLLI
                        when "101" =>
                            if f7 = "0000000" then ICode <= "0101"; -- SRLI
                            elsif f7 = "0100000" then ICode <= "0110"; -- SRAI
                            end if;
                        when "010" => ICode <= "0111"; -- SLTI
                        when "011" => ICode <= "1000"; -- SLTIU
                        when others => null;
                    end case;
                end if;

            -- S-type: SB, SH, SW
            when "0100011" =>
                TypeSel <= "000";
                case f3 is
                    when "000" => ICode <= "0000"; -- SB
                    when "001" => ICode <= "0001"; -- SH
                    when "010" => ICode <= "0010"; -- SW
                    when others => null;
                end case;

            -- B-type: BEQ, BNE, BLT, BGE, BLTU, BGEU
            when "1100011" =>
                TypeSel <= "010";
                case f3 is
                    when "000" => ICode <= "0000"; -- BEQ
                    when "001" => ICode <= "0001"; -- BNE
                    when "100" => ICode <= "0010"; -- BLT
                    when "101" => ICode <= "0011"; -- BGE
                    when "110" => ICode <= "0100"; -- BLTU
                    when "111" => ICode <= "0101"; -- BGEU
                    when others => null;
                end case;

            -- J-type: JAL
            when "1101111" =>
                TypeSel <= "011";
                ICode   <= "0000";

            -- U-type: LUI, AUIPC
            when "0110111" =>
                TypeSel <= "100";
                ICode   <= "0000"; -- LUI
            when "0010111" =>
                TypeSel <= "100";
                ICode   <= "0001"; -- AUIPC

            -- WFI
            when "1110011" =>
                if Instruction(31 downto 20) = "000100000101" then
                    TypeSel <= "111";
                    ICode   <= "0000";
                end if;

            when others =>
                TypeSel  <= "111";
                ICode   <= "1111";
        end case;
    end process;

end Behavioral;






--testBench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity testPreDecode is
end entity;

architecture testeandoPreDecode of testPreDecode is
    signal Instruction : std_logic_vector(31 downto 0) := (others => '0');
    signal Opcode      : std_logic_vector(6 downto 0);
    signal Funct3      : std_logic_vector(2 downto 0);
    signal Funct7      : std_logic_vector(6 downto 0);
    signal Rd, Rs1, Rs2: std_logic_vector(4 downto 0);
    signal TypeSel     : std_logic_vector(2 downto 0);
    signal ICode       : std_logic_vector(3 downto 0);
begin

    PreDecode_use: entity work.PreDecode(Behavioral)
        port map(
            Instruction => Instruction,
            Opcode      => Opcode,
            Funct3      => Funct3,
            Funct7      => Funct7,
            Rd          => Rd,
            Rs1         => Rs1,
            Rs2         => Rs2,
            TypeSel     => TypeSel,
            ICode       => ICode
        );

    Instruction <= 
        X"002081b3" after 0 ns,   -- ADD x3, x1, x2  (R-Type) -> TypeSel: 101, ICode: 0000
        X"00a08093" after 20 ns,  -- ADDI x1, x1, 10 (I-Type) -> TypeSel: 001, ICode: 0000
        X"0020a223" after 40 ns,  -- SW x2, 4(x1)    (S-Type) -> TypeSel: 000, ICode: 0010
        X"fe000ee3" after 60 ns,  -- BEQ x0, x0, -4  (B-Type) -> TypeSel: 010, ICode: 0000
        X"10500073" after 80 ns;  -- WFI             (System) -> TypeSel: 111, ICode: 0000

end architecture;
