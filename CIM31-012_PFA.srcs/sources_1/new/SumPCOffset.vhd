----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.04.2026 17:18:13
-- Design Name: 
-- Module Name: SumPCOffset - Behavioral
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

entity SumPCOffset is
    port(
        CPin, offset: in std_logic_vector(31 downto 0);
        CPOffsetOut: out std_logic_vector(31 downto 0)
    );
end SumPCOffset;

architecture Behavioral of SumPCOffset is
begin

    CPOffsetOut <= std_logic_vector(signed(CPin) + signed(offset));

end Behavioral;
