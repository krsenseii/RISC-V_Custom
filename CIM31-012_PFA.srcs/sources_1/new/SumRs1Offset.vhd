----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.05.2026 20:59:30
-- Design Name: 
-- Module Name: SumRdOffset - Behavioral
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

entity SumRs1Offset is
    port(
        rs1    : in  std_logic_vector(31 downto 0);
        offset : in  std_logic_vector(31 downto 0);
        res    : out std_logic_vector(31 downto 0)
    );
end SumRs1Offset;

architecture Behavioral of SumRs1Offset is
begin
    res <= std_logic_vector(signed(rs1) + signed(offset));
end Behavioral;





--testBench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity testSumRs1Offset is
end entity;

architecture testeandoSumRs1Offset of testSumRs1Offset is
    signal rs1    : std_logic_vector(31 downto 0) := (others => '0');
    signal offset : std_logic_vector(31 downto 0) := (others => '0');
    signal res    : std_logic_vector(31 downto 0);
begin

    SumRs1Offset_use: entity work.SumRs1Offset(Behavioral)
        port map(
            rs1    => rs1,
            offset => offset,
            res    => res
        );

    rs1 <= X"00001000" after 0 ns,
           X"00002000" after 60 ns; 

    offset <= X"00000004" after 0 ns,   -- dirección 1004 suma 
              X"0000000C" after 20 ns,  -- dirección 100C suma 
              X"FFFFFFFC" after 40 ns,  -- dirección 0FFC salto -4
              X"00000008" after 80 ns;  -- dirección 2008 base + 8

end architecture;