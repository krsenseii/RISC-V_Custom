----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.05.2026 20:40:08
-- Design Name: 
-- Module Name: MemData - Behavioral
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

entity MemDatos is
    generic(
        address_bits : integer := 10 -- 1024 palabras
    );
    port(
        clk       : in  std_logic;
        enable_n  : in  std_logic; -- activo nivel bajo '0'
        read_n    : in  std_logic; -- activo nivel bajo '0'
        write_n   : in  std_logic_vector(3 downto 0); -- máscara: selección byte
        direccion : in  std_logic_vector(31 downto 0);
        dataIn    : in  std_logic_vector(31 downto 0);
        dataOut   : out std_logic_vector(31 downto 0)
    );
end MemDatos;

architecture Behavioral of MemDatos is
    type ram_t is array (0 to 2**address_bits - 1) of std_logic_vector(31 downto 0);
    signal RAM : ram_t := (others => (others => '0'));
    
    signal direccion_word : std_logic_vector(address_bits-1 downto 0);
    
begin

        direccion_word <= direccion(address_bits + 1 downto 2);

    process(clk)
    begin
        if rising_edge(clk) then
            if enable_n = '0' then

                -- Byte 0
                if write_n(0) = '0' then
                    RAM(to_integer(unsigned(direccion_word)))(7 downto 0)
                        <= dataIn(7 downto 0);
                end if;

                -- Byte 1
                if write_n(1) = '0' then
                    RAM(to_integer(unsigned(direccion_word)))(15 downto 8)
                        <= dataIn(15 downto 8);
                end if;

                -- Byte 2
                if write_n(2) = '0' then
                    RAM(to_integer(unsigned(direccion_word)))(23 downto 16)
                        <= dataIn(23 downto 16);
                end if;

                -- Byte 3
                if write_n(3) = '0' then
                    RAM(to_integer(unsigned(direccion_word)))(31 downto 24)
                        <= dataIn(31 downto 24);
                end if;

            end if;
        end if;
    end process;

    dataOut <= RAM(to_integer(unsigned(direccion_word))) -- lectura asíncrona
           when (enable_n = '0' and read_n = '0')
           else (others => '0');

end Behavioral;




--testBench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity testMemData is
end entity;

architecture testeandoMemData of testMemData is

    signal clk       : std_logic := '0';
    signal en_n      : std_logic := '1';
    signal rd_n      : std_logic := '1';
    signal wr_n      : std_logic_vector(3 downto 0) := "1111";

    signal direccion : std_logic_vector(31 downto 0) := (others => '0');

    signal dataIn    : std_logic_vector(31 downto 0) := (others => '0');
    signal dataOut   : std_logic_vector(31 downto 0);

begin

    MemData_use: entity work.MemDatos(Behavioral)
        port map (
            clk       => clk,
            enable_n  => en_n,
            read_n    => rd_n,
            write_n   => wr_n,
            direccion => direccion,
            dataIn    => dataIn,
            dataOut   => dataOut
        );

    process
    begin
        clk <= '0';
        wait for 5 ns;

        clk <= '1';
        wait for 5 ns;
    end process;

    process
    begin

        -- t = 0 
        en_n      <= '1';
        rd_n      <= '1';
        wr_n      <= "1111";

        direccion <= x"00000000";
        dataIn    <= x"00000000";

        wait for 20 ns;
        -- t = 20 
        en_n      <= '0';

        wr_n      <= "0000";
        rd_n      <= '1';

        direccion <= x"00000004";
        dataIn    <= x"DEADBEEF";

        wait for 10 ns;
        -- t = 30 
        wr_n <= "1111";
        rd_n <= '0';

        wait for 10 ns;
        -- t = 40 
        rd_n <= '1';
        wr_n <= "1101";

        direccion <= x"00000008";
        dataIn    <= x"1230AA01";

        wait for 10 ns;
        -- t = 50 
        wr_n <= "1111";
        rd_n <= '0';

        wait for 10 ns;
        -- t = 60 
        rd_n <= '1';
        wr_n <= "0011";

        direccion <= x"0000000C";
        dataIn    <= x"BEEF0123";

        wait for 10 ns;
        -- t = 70 
        wr_n <= "1111";
        rd_n <= '0';

        wait for 10 ns;
        -- t = 80 
        en_n <= '1';
        rd_n <= '1';
        wr_n <= "1111";

        wait;

    end process;

end architecture;