library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MemInstr is
    generic(
        address_bits : integer := 10 -- 1024 palabras (4KB)
    );
    port(
        clk : in std_logic;
        we  : in std_logic;
        din : in std_logic_vector(31 downto 0);
        direccion    : in  std_logic_vector(31 downto 0); -- Dirección a leer/escribir
        instruccion  : out std_logic_vector(31 downto 0)  -- Instrucción que sale a la CPU
    );
end MemInstr;

architecture Behavioral of MemInstr is
    type ram_t is array (0 to 2**address_bits - 1) of std_logic_vector(31 downto 0);
    
    signal RAM : ram_t := (
        others => x"00000013" -- NOP (addi x0, x0, 0)
    );
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if we = '1' then
               RAM(to_integer(unsigned(direccion(address_bits-1 downto 0)))) <= din;
            end if;
        end if;
    end process;

instruccion <= RAM(to_integer(unsigned(direccion(address_bits-1 downto 0))));
end Behavioral; 