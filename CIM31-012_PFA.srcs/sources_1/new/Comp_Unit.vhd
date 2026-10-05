----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.05.2026 19:05:16
-- Design Name: 
-- Module Name: Comp_Unit - Behavioral
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

entity Comp_Unit is
    Port ( 
        A, B : in  std_logic_vector(31 downto 0);
        Op   : in  std_logic; -- '0' para SLT (con signo), '1' para SLTU (sin signo)
        Res  : out std_logic_vector(31 downto 0)
    );
end Comp_Unit;

architecture Behavioral of Comp_Unit is
begin
    process(A, B, Op)
    begin
        if Op = '0' then -- SLT
            if signed(A) < signed(B) then Res <= x"00000001"; else Res <= x"00000000"; end if;
        else -- SLTU
            if unsigned(A) < unsigned(B) then Res <= x"00000001"; else Res <= x"00000000"; end if;
        end if;
    end process;
end Behavioral;






-- testBench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity testCompUnit is
end entity;

architecture testeandoCompUnit of testCompUnit is
    signal a   : std_logic_vector(31 downto 0) := (others => '0');
    signal b   : std_logic_vector(31 downto 0) := (others => '0');
    signal op  : std_logic := '0';
    signal res : std_logic_vector(31 downto 0);
begin

    DUT: entity work.Comp_Unit(Behavioral)
        port map(
            A   => a,
            B   => b,
            Op  => op,
            Res => res
        );

    process
    begin
        -- SLT: -1 < 5 -> 1
        a  <= x"FFFFFFFF";
        b  <= x"00000005";
        op <= '0';
        wait for 20 ns;

        -- SLT: 5 < -1 -> 0
        a  <= x"00000005";
        b  <= x"FFFFFFFF";
        op <= '0';
        wait for 20 ns;

        -- SLTU: 0xFFFFFFFF < 5 -> 0
        a  <= x"FFFFFFFF";
        b  <= x"00000005";
        op <= '1';
        wait for 20 ns;

        -- SLTU: 2 < 5 -> 1
        a  <= x"00000002";
        b  <= x"00000005";
        op <= '1';
        wait for 20 ns;

        -- Igualdad: 2 < 2 -> 0
        a  <= x"00000002";
        b  <= x"00000002";
        op <= '0';
        wait for 20 ns;

        wait;
    end process;

end architecture;