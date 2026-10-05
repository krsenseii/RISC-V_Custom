library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Decoder4_16 is
    Port (
        Entrada : in  std_logic_vector(3 downto 0);
        Enable  : in  std_logic;
        Salida  : out std_logic_vector(15 downto 0)
    );
end Decoder4_16;

architecture Behavioral of Decoder4_16 is
    signal s_decodificado : std_logic_vector(15 downto 0);
begin
    -- Generamos un único CERO en la posición correcta, el resto UNOS
    with Entrada select s_decodificado <=
        "1111111111111110" when "0000",
        "1111111111111101" when "0001",
        "1111111111111011" when "0010",
        "1111111111110111" when "0011",
        "1111111111101111" when "0100",
        "1111111111011111" when "0101",
        "1111111110111111" when "0110",
        "1111111101111111" when "0111",
        "1111111011111111" when "1000",
        "1111110111111111" when "1001",
        "1111101111111111" when "1010",
        "1111011111111111" when "1011",
        "1110111111111111" when "1100",
        "1101111111111111" when "1101",
        "1011111111111111" when "1110",
        "0111111111111111" when "1111",
        "1111111111111111" when others;

    -- LÓGICA NEGADA: Si Enable es '0', pasamos la señal (escribimos). 
    -- Si es '1', ponemos todos a '1' para bloquear todos los flip-flops.
    Salida <= s_decodificado when Enable = '0' else "1111111111111111";

end Behavioral;