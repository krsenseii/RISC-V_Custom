----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.05.2026 18:51:23
-- Design Name: 
-- Module Name: Logic_Unit - Behavioral
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

entity Logic_Unit is
    Port ( 
        A, B : in  std_logic_vector(31 downto 0);
        Op   : in  std_logic_vector(1 downto 0); -- 00:AND, 01:OR, 10:XOR
        Res  : out std_logic_vector(31 downto 0)
    );
end Logic_Unit;

architecture Behavioral of Logic_Unit is
begin
    with Op select
        Res <= A and B when "00",
               A or B  when "01",
               A xor B when "10",
               (others => '0') when others;
end Behavioral;







-- testBench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity testLogicUnit is
end entity;

architecture testeandoLogicUnit of testLogicUnit is
    signal a   : std_logic_vector(31 downto 0) := (others => '0');
    signal b   : std_logic_vector(31 downto 0) := (others => '0');
    signal op  : std_logic_vector(1 downto 0) := "00";
    signal res : std_logic_vector(31 downto 0);
begin

    LogicUnit_use: entity work.Logic_Unit(Behavioral)
        port map(
            A   => a,
            B   => b,
            Op  => op,
            Res => res
        );

    process
    begin
        -- AND
        a  <= x"FFFF0000";
        b  <= x"00FF00FF";
        op <= "00";
        wait for 20 ns;

        -- OR
        op <= "01";
        wait for 20 ns;

        -- XOR
        op <= "10";
        wait for 20 ns;

        -- no definido -> 0
        op <= "11";
        wait for 20 ns;

        -- AND
        a  <= x"AAAAAAAA";
        b  <= x"55555555";
        op <= "00";
        wait for 20 ns;

        wait;
    end process;

end architecture;