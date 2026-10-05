----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.05.2026 18:46:16
-- Design Name: 
-- Module Name: Arith_Unit - Behavioral
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

entity Arith_Unit is
    Port ( 
        A, B : in  std_logic_vector(31 downto 0);
        Op   : in  std_logic; -- '0' ADD, '1' SUB
        F  : out std_logic_vector(31 downto 0)
    );
end Arith_Unit;

architecture Behavioral of Arith_Unit is
    signal opA, opB, res : signed(31 downto 0);
begin
    
    opA <= signed(A);
    opB <= signed(B);
    res <= opA + opB when Op = '0' else opA - opB; 
    F <= std_logic_vector(res);

end Behavioral;







-- testBench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity testArithUnit is
end entity;

architecture testeandoArithUnit of testArithUnit is
    signal a   : std_logic_vector(31 downto 0) := (others => '0');
    signal b   : std_logic_vector(31 downto 0) := (others => '0');
    signal op  : std_logic := '0';
    signal f   : std_logic_vector(31 downto 0);
begin

    ArithUnit_use: entity work.Arith_Unit(Behavioral)
        port map(
            A  => a,
            B  => b,
            Op => op,
            F  => f
        );

    process
    begin
        -- ADD: 10 + 5 = 15
        a  <= x"0000000A";
        b  <= x"00000005";
        op <= '0';
        wait for 20 ns;

        -- SUB: 10 - 5 = 5
        op <= '1';
        wait for 20 ns;

        -- SUB: 10 - 10 = 0
        b <= x"0000000A";
        wait for 20 ns;

        -- ADD con número negativo: 10 + (-2) = 8
        op <= '0';
        b  <= x"FFFFFFFE";
        wait for 20 ns;

        -- SUB con número negativo: 10 - (-2) = 12
        op <= '1';
        wait for 20 ns;

        -- ADD negativo + negativo
        a  <= x"FFFFFFF0"; -- -16
        b  <= x"FFFFFFF1"; -- -15
        op <= '0';
        wait for 20 ns;

        wait;
    end process;

end architecture;
