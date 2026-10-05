----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.05.2026 18:39:53
-- Design Name: 
-- Module Name: MUX4_Reg - Behavioral
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

entity MUX4_Reg is
    Port ( 
        D_ALU     : in  std_logic_vector(31 downto 0); -- 00
        D_Mem     : in  std_logic_vector(31 downto 0); -- 01
        D_Imm     : in  std_logic_vector(31 downto 0); -- 10
        D_CP      : in  std_logic_vector(31 downto 0); -- 11
        Sel       : in  std_logic_vector(1 downto 0);
        D_Out     : out std_logic_vector(31 downto 0)
    );
end MUX4_Reg;

architecture Behavioral of MUX4_Reg is
begin
    with Sel select
        D_Out <= D_ALU when "00",
                 D_Mem when "01",
                 D_Imm when "10",
                 D_CP  when others; -- "11"
end Behavioral;





--testBench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity testMUX4Reg is
end entity;

architecture testeandoMUX4Reg of testMUX4Reg is
    signal D_ALU : std_logic_vector(31 downto 0) := X"00000001";
    signal D_Mem : std_logic_vector(31 downto 0) := X"00000002";
    signal D_Imm : std_logic_vector(31 downto 0) := X"00000003";
    signal D_CP  : std_logic_vector(31 downto 0) := X"00000004";
    signal Sel   : std_logic_vector(1 downto 0)  := "00";
    signal D_Out : std_logic_vector(31 downto 0);
begin

    MUX4Reg_use: entity work.MUX4_Reg(Behavioral)
        port map(
            D_ALU => D_ALU, D_Mem => D_Mem,
            D_Imm => D_Imm, D_CP  => D_CP,
            Sel   => Sel,   D_Out => D_Out
        );

    Sel <= "00" after 0 ns,   -- ALU 
           "01" after 20 ns,  -- Mem 
           "10" after 40 ns,  -- Imm 
           "11" after 60 ns;  -- CP  

end architecture;
