----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.05.2026 18:44:52
-- Design Name: 
-- Module Name: MUX4_ALU - Behavioral
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

entity MUX4_ALU is
    Port (
        D_Reg : in  std_logic_vector(31 downto 0); -- rs2
        D_Imm : in  std_logic_vector(31 downto 0); -- ImmGen
        Sel     : in  std_logic;                     -- 0: registro, 1: immgen
        OutData : out std_logic_vector(31 downto 0)
    );
end MUX4_ALU;

architecture Behavioral of MUX4_ALU is
begin
    OutData <= D_Reg when Sel = '0' else D_Imm;
end Behavioral;






--testBench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity testMUX4ALU is
end entity;

architecture testeandoMUX4ALU of testMUX4ALU is
    signal D_Reg : std_logic_vector(31 downto 0) := X"AAAAAAAA";
    signal D_Imm : std_logic_vector(31 downto 0) := X"55555555";
    signal Sel     : std_logic := '0';
    signal OutData : std_logic_vector(31 downto 0);
begin

    MUX4ALU_use: entity work.MUX4_ALU(Behavioral)
        port map(
            D_Reg => D_Reg,
            D_Imm => D_Imm,
            Sel     => Sel,
            OutData => OutData
        );

    Sel <= '0' after 0 ns,  -- AAAAAAAA
           '1' after 20 ns, -- 55555555
           '0' after 40 ns;

    D_Reg <= X"12345678" after 50 ns; 

end architecture;
