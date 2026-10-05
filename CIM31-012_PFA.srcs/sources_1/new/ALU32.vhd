----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.05.2026 19:44:21
-- Design Name: 
-- Module Name: ALU32 - Estructural
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

entity ALU32 is
    Port ( 
        A, B     : in  std_logic_vector(31 downto 0);
        Selector : in  std_logic_vector(3 downto 0);
        Z        : out std_logic_vector(31 downto 0);
        ZeroFlag : out std_logic
    );
end ALU32;

architecture Structural of ALU32 is

    signal sArit, sLogic, sShift, sComp, sOut : std_logic_vector(31 downto 0);

begin

    ArithUnit_use: entity work.Arith_Unit(Behavioral)
        port map(
            A  => A,
            B  => B,
            Op => Selector(0),
            F  => sArit
        );

    LogicUnit_use: entity work.Logic_Unit(Behavioral)
        port map(
            A   => A,
            B   => B,
            Op  => Selector(1 downto 0),
            Res => sLogic
        );

    ShiftUnit_use: entity work.Shift_Unit(Behavioral)
        port map(
            A   => A,
            B   => B,
            Op  => Selector(1 downto 0),
            Res => sShift
        );

    CompUnit_use: entity work.Comp_Unit(Behavioral)
        port map(
            A   => A,
            B   => B,
            Op  => Selector(0),
            Res => sComp
        );

    with Selector(3 downto 2) select
        sOut <= sArit  when "00",
                sLogic when "01",
                sShift when "10",
                sComp  when "11",
                (others => '0') when others;

    Z <= sOut;
    ZeroFlag <= '1' when sOut = x"00000000" else '0';

end Structural;






-- testBench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TestALU32 is
end TestALU32;

architecture Behavioral of TestALU32 is

    component ALU32 is
        Port ( 
            A        : in std_logic_vector (31 downto 0);
            B        : in std_logic_vector (31 downto 0);
            Selector : in std_logic_vector (3 downto 0);
            ZeroFlag : out std_logic;
            Z        : out std_logic_vector (31 downto 0) 
        );
    end component;

    signal s_A        : std_logic_vector(31 downto 0) := (others => '0');
    signal s_B        : std_logic_vector(31 downto 0) := (others => '0');
    signal s_Selector : std_logic_vector(3 downto 0) := "0000";
    signal s_ZeroFlag : std_logic;
    signal s_Z        : std_logic_vector(31 downto 0);

begin

    InstTest: ALU32 
        port map (
            A        => s_A,
            B        => s_B,
            Selector => s_Selector,
            ZeroFlag => s_ZeroFlag,
            Z        => s_Z
        );

    process
    begin

        -- ADD: 10 + 5 = 15
        s_A <= x"0000000A"; 
        s_B <= x"00000005"; 
        s_Selector <= "0000"; 
        wait for 20 ns; 

        -- SUB: 10 - 5 = 5
        s_Selector <= "0001"; 
        wait for 20 ns;

        -- SUB: 10 - 10 = 0 (ZeroFlag = 1)
        s_B <= x"0000000A"; 
        wait for 20 ns;


        -- AND
        s_A <= x"FFFF0000"; 
        s_B <= x"00FF00FF"; 
        s_Selector <= "0100"; 
        wait for 20 ns;

        -- OR
        s_Selector <= "0101"; 
        wait for 20 ns;

        -- XOR
        s_Selector <= "0110"; 
        wait for 20 ns;


        -- SLL: shift left
        s_A <= x"8000000F"; 
        s_B <= x"00000004"; 
        s_Selector <= "1000"; 
        wait for 20 ns;

        -- SRL: shift right lógico
        s_Selector <= "1001"; 
        wait for 20 ns;

        -- SRA: shift right aritmético
        s_Selector <= "1010"; 
        wait for 20 ns;


        -- SLT: -1 < 5 → 1
        s_A <= x"FFFFFFFF"; 
        s_B <= x"00000005"; 
        s_Selector <= "1100"; 
        wait for 20 ns;

        -- SLTU: (unsigned) 0xFFFFFFFF < 5 → 0
        s_Selector <= "1101"; 
        wait for 20 ns;

        wait;
    end process;

end Behavioral;
