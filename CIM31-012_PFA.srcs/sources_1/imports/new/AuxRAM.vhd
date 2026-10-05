----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.05.2026 21:00:39
-- Design Name: 
-- Module Name: AuxRAM - Behavioral
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

entity AuxRAM is
    generic(
        address_bits : integer := 10 -- 1024 palabras
    );
    port(
        clk           : in  std_logic;
        
        MascWrite_n   : in  std_logic_vector(3 downto 0);
        direccion     : in  std_logic_vector(31 downto 0);
        dataIn        : in  std_logic_vector(31 downto 0);
        
        dataOut       : out std_logic_vector(31 downto 0);
        
        dataOutAux    : out std_logic_vector(31 downto 0);
        direccionAux  : in  std_logic_vector(31 downto 0)
    );
end AuxRAM;

architecture Behavioral of AuxRAM is
    type ram_t is array (0 to 2**address_bits - 1) of std_logic_vector(31 downto 0);
    signal RAM : ram_t := (others => (others => '0'));

    signal direccion_word     : std_logic_vector(address_bits-1 downto 0);
    signal direccionAux_word  : std_logic_vector(address_bits-1 downto 0);

begin

    direccion_word    <= direccion(address_bits + 1 downto 2);
    direccionAux_word <= direccionAux(address_bits + 1 downto 2);

    process(clk)
    begin
        if rising_edge(clk) then
                if MascWrite_n(0) = '0' then
                    RAM(to_integer(unsigned(direccion_word)))(7 downto 0)
                        <= dataIn(7 downto 0);
                end if;

                if MascWrite_n(1) = '0' then
                    RAM(to_integer(unsigned(direccion_word)))(15 downto 8)
                        <= dataIn(15 downto 8);
                end if;

                if MascWrite_n(2) = '0' then
                    RAM(to_integer(unsigned(direccion_word)))(23 downto 16)
                        <= dataIn(23 downto 16);
                end if;

                if MascWrite_n(3) = '0' then
                    RAM(to_integer(unsigned(direccion_word)))(31 downto 24)
                        <= dataIn(31 downto 24);
                end if;

       end if;
    end process;
    
    
    -- Lectura siempre activa
    dataOut <= RAM(to_integer(unsigned(direccion_word)));
    dataOutAux <= RAM(to_integer(unsigned(direccionAux_word)));
    
end Behavioral;
