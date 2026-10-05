----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.04.2026 12:13:30
-- Design Name: 
-- Module Name: R32 - Estructural
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

entity R32 is
    port(
        clk, reset, WriteEnable : in  STD_LOGIC;
        R32in  : in  STD_LOGIC_VECTOR(31 downto 0);
        R32out   : out STD_LOGIC_VECTOR(31 downto 0)
    );
end R32;

architecture Estructural of R32 is
begin

    registro: for i in 0 to 31 generate
      FF_D_use: entity work.FF_D(Behavioral)
        port map(
            D => R32in(i),
            Q => R32out(i),
            clk => clk,
            clear => reset,
            preset => '1',
            enable => WriteEnable
        );
    end generate;

end Estructural;








-- testBench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity testR32 is
end entity;

architecture testeandoR32 of testR32 is
    signal clk   : std_logic := '0';
    signal reset, WriteEnable : std_logic := '1'; 
    signal R32in : std_logic_vector(31 downto 0) := (others => '0');
    signal R32out: std_logic_vector(31 downto 0);
begin

    R32_use: entity work.R32(Estructural)
        port map(
            clk    => clk,
            reset  => reset,
            R32in  => R32in,
            R32out => R32out,
            WriteEnable => WriteEnable 
        );

    process
    begin
        clk <= '0'; wait for 5 ns;
        clk <= '1'; wait for 5 ns;
    end process;

    R32in       <= X"40000000" after 0 ns, X"80000000" after 20 ns;
    reset       <= '0' after 20 ns, '1' after 23 ns;
    WriteEnable <= '1' after 0 ns, '0' after 12 ns, '1' after 28 ns;
    
end architecture testeandoR32;