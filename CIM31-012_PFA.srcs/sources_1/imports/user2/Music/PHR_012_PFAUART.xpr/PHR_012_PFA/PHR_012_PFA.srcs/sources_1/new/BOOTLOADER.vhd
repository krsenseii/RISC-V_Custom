library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bootloader is
    Port (
        clk        : in  std_logic;
        enable     : in  std_logic; -- Conectado al sw(15). Si está a 0, se resetea.
        uart_data  : in  std_logic_vector(7 downto 0);
        uart_ready : in  std_logic;
        
        -- Salidas hacia la Memoria RAM
        ram_we     : out std_logic;
        ram_addr   : out std_logic_vector(31 downto 0);
        ram_data   : out std_logic_vector(31 downto 0)
    );
end bootloader;

architecture Behavioral of bootloader is
    -- Máquina de estados para contar los 4 bytes (0 a 3)
    signal byte_count : integer range 0 to 3 := 0;
    
    -- Registro temporal para ir montando la instrucción de 32 bits
    signal buffer_inst : std_logic_vector(31 downto 0) := (others => '0');
    
    -- Puntero de memoria que irá sumando de 4 en 4
    signal current_addr : unsigned(31 downto 0) := (others => '0');
begin

    process(clk)
    begin
        if rising_edge(clk) then
            
            -- Valores por defecto para que no escriba basura
            ram_we <= '0'; 

            if enable = '0' then
                -- Si el modo programación está apagado, reseteamos todo
                -- para que la próxima vez empiece a guardar desde la dirección 0.
                byte_count <= 0;
                current_addr <= (others => '0');
                
            else
                -- Estamos en modo programación. Escuchamos al UART.
                if uart_ready = '1' then
                    
                    if byte_count = 0 then
                        -- Llega el Byte 1 (Bits 31 a 24)
                        buffer_inst(31 downto 24) <= uart_data;
                        byte_count <= 1;
                        
                    elsif byte_count = 1 then
                        -- Llega el Byte 2 (Bits 23 a 16)
                        buffer_inst(23 downto 16) <= uart_data;
                        byte_count <= 2;
                        
                    elsif byte_count = 2 then
                        -- Llega el Byte 3 (Bits 15 a 8)
                        buffer_inst(15 downto 8) <= uart_data;
                        byte_count <= 3;
                        
                    elsif byte_count = 3 then
                        -- Llega el Byte 4 (Bits 7 a 0). ¡INSTRUCCIÓN COMPLETA!
                        -- Juntamos este último byte con lo que ya teníamos
                        ram_data <= buffer_inst(31 downto 8) & uart_data;
                        ram_addr <= std_logic_vector(current_addr);
                        
                        -- ¡Fuego! Disparamos el gatillo de escritura de la RAM
                        ram_we <= '1'; 
                        
                        -- Avanzamos el puntero de memoria para la próxima instrucción
                        current_addr <= current_addr + 1; 
                        
                        -- Volvemos a empezar para la siguiente instrucción
                        byte_count <= 0; 
                    end if;
                end if;
            end if;
        end if;
    end process;

end Behavioral;