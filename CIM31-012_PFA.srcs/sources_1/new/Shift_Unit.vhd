----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.05.2026 18:57:13
-- Design Name: 
-- Module Name: Shift_Unit - Behavioral
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

entity Shift_Unit is
    Port ( 
        A : in  std_logic_vector (31 downto 0); -- Dato
        B : in  std_logic_vector (31 downto 0); -- nº desplazamientos
        Op   : in  std_logic_vector(1 downto 0); -- 00:SLL, 01:SRL, 10:SRA
        Res  : out std_logic_vector(31 downto 0)
    );
end Shift_Unit;

architecture Behavioral of Shift_Unit is
begin
    process(A, B, Op)
        variable n_slide : integer range 0 to 31;
    begin
        n_slide := to_integer(unsigned(B(4 downto 0)));
        case Op is
            when "00" => Res <= std_logic_vector(shift_left(unsigned(A), n_slide));
            when "01" => Res <= std_logic_vector(shift_right(unsigned(A), n_slide));
            when "10" => Res <= std_logic_vector(shift_right(signed(A), n_slide));
            when others => Res <= (others => '0');
        end case;
    end process;
end Behavioral;





-- testBench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity testShiftUnit is
end entity;

architecture testeandoShiftUnit of testShiftUnit is
    signal a   : std_logic_vector(31 downto 0) := (others => '0');
    signal b   : std_logic_vector(31 downto 0) := (others => '0');
    signal op  : std_logic_vector(1 downto 0) := "00";
    signal res : std_logic_vector(31 downto 0);
begin

    DUT: entity work.Shift_Unit(Behavioral)
        port map(
            A   => a,
            B   => b,
            Op  => op,
            Res => res
        );

    process
    begin
        -- SLL: 1 << 4 = 16
        a  <= x"00000001";
        b  <= x"00000004";
        op <= "00";
        wait for 20 ns;

        -- SRL: 16 >> 2 = 4
        a  <= x"00000010";
        b  <= x"00000002";
        op <= "01";
        wait for 20 ns;

        -- SRA: número negativo
        a  <= x"80000000";
        b  <= x"00000001";
        op <= "10";
        wait for 20 ns;

        -- SRA: -1 >> 3 = -1
        a  <= x"FFFFFFFF";
        b  <= x"00000003";
        op <= "10";
        wait for 20 ns;

        -- no definido -> 0
        op <= "11";
        wait for 20 ns;

        wait;
    end process;

end architecture;