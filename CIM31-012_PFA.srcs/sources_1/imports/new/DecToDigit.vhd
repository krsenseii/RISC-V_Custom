----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.06.2026 17:41:14
-- Design Name: 
-- Module Name: DecToDigit - Behavioral
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


entity DecToDigit is
    port(
        clk             : in  std_logic;
        
        sign_sRAM       : in std_logic_vector(4 downto 0);
        dRAM_digits     : in std_logic_vector(39 downto 0);
        addrRAM_digits  : in std_logic_vector(15 downto 0);
        
        sign_dAux       : in std_logic_vector(4 downto 0);
        dAux_digits     : in std_logic_vector(39 downto 0);
        addrAux_digits  : in std_logic_vector(15 downto 0);
        
        
        weTextRAM_n     : out std_logic; -- 0 write textRAM
        addressTextRAM  : out std_logic_vector(9 downto 0);
        character_out   : out std_logic_vector(4 downto 0);
    
        
        dirReadReg      : out std_logic_vector(3 downto 0);
        sign_dReg       : in  std_logic_vector(4 downto 0);
        dReg_digits     : in  std_logic_vector(39 downto 0)
    );
end DecToDigit;


architecture Behavioral of DecToDigit is
    signal contador : integer range 0 to 29 := 0;
    
    -- Señales barrido
    signal phase      : std_logic := '0'; 
    signal reg_idx    : integer range 0 to 15 := 0;
    signal reg_step   : integer range 0 to 12 := 0; 
    
    constant BASE_START : integer := 132; 
    constant ROW_OFFSET : integer := 32;  
begin

    process(clk)
        variable base_addr : integer;
    begin
        if rising_edge(clk) then
            weTextRAM_n <= '0';

            -- fase ram
            if phase = '0' then
                case contador is
                    -- dRAM: base 4 
                    when 0 =>  addressTextRAM <= std_logic_vector(to_unsigned(4, 10));  character_out <= sign_sRAM;
                    when 1 =>  addressTextRAM <= std_logic_vector(to_unsigned(5, 10));  character_out <= '0' & dRAM_digits(39 downto 36);
                    when 2 =>  addressTextRAM <= std_logic_vector(to_unsigned(6, 10));  character_out <= '0' & dRAM_digits(35 downto 32);
                    when 3 =>  addressTextRAM <= std_logic_vector(to_unsigned(7, 10));  character_out <= '0' & dRAM_digits(31 downto 28);
                    when 4 =>  addressTextRAM <= std_logic_vector(to_unsigned(8, 10));  character_out <= '0' & dRAM_digits(27 downto 24);
                    when 5 =>  addressTextRAM <= std_logic_vector(to_unsigned(9, 10));  character_out <= '0' & dRAM_digits(23 downto 20);
                    when 6 =>  addressTextRAM <= std_logic_vector(to_unsigned(10, 10)); character_out <= '0' & dRAM_digits(19 downto 16);
                    when 7 =>  addressTextRAM <= std_logic_vector(to_unsigned(11, 10)); character_out <= '0' & dRAM_digits(15 downto 12);
                    when 8 =>  addressTextRAM <= std_logic_vector(to_unsigned(12, 10)); character_out <= '0' & dRAM_digits(11 downto 8);
                    when 9 =>  addressTextRAM <= std_logic_vector(to_unsigned(13, 10)); character_out <= '0' & dRAM_digits(7 downto 4);
                    when 10 => addressTextRAM <= std_logic_vector(to_unsigned(14, 10)); character_out <= '0' & dRAM_digits(3 downto 0);

                    -- addrRAM: base 37 
                    when 11 => addressTextRAM <= std_logic_vector(to_unsigned(37, 10)); character_out <= '0' & addrRAM_digits(15 downto 12);
                    when 12 => addressTextRAM <= std_logic_vector(to_unsigned(38, 10)); character_out <= '0' & addrRAM_digits(11 downto 8);
                    when 13 => addressTextRAM <= std_logic_vector(to_unsigned(39, 10)); character_out <= '0' & addrRAM_digits(7 downto 4);
                    when 14 => addressTextRAM <= std_logic_vector(to_unsigned(40, 10)); character_out <= '0' & addrRAM_digits(3 downto 0);

                    -- dAux: base 710 
                    when 15 => addressTextRAM <= std_logic_vector(to_unsigned(710, 10)); character_out <= sign_dAux;
                    when 16 => addressTextRAM <= std_logic_vector(to_unsigned(711, 10)); character_out <= '0' & dAux_digits(39 downto 36);
                    when 17 => addressTextRAM <= std_logic_vector(to_unsigned(712, 10)); character_out <= '0' & dAux_digits(35 downto 32);
                    when 18 => addressTextRAM <= std_logic_vector(to_unsigned(713, 10)); character_out <= '0' & dAux_digits(31 downto 28);
                    when 19 => addressTextRAM <= std_logic_vector(to_unsigned(714, 10)); character_out <= '0' & dAux_digits(27 downto 24);
                    when 20 => addressTextRAM <= std_logic_vector(to_unsigned(715, 10)); character_out <= '0' & dAux_digits(23 downto 20);
                    when 21 => addressTextRAM <= std_logic_vector(to_unsigned(716, 10)); character_out <= '0' & dAux_digits(19 downto 16);
                    when 22 => addressTextRAM <= std_logic_vector(to_unsigned(717, 10)); character_out <= '0' & dAux_digits(15 downto 12);
                    when 23 => addressTextRAM <= std_logic_vector(to_unsigned(718, 10)); character_out <= '0' & dAux_digits(11 downto 8);
                    when 24 => addressTextRAM <= std_logic_vector(to_unsigned(719, 10)); character_out <= '0' & dAux_digits(7 downto 4);
                    when 25 => addressTextRAM <= std_logic_vector(to_unsigned(720, 10)); character_out <= '0' & dAux_digits(3 downto 0);

                    -- addrAux: base 743 
                    when 26 => addressTextRAM <= std_logic_vector(to_unsigned(743, 10)); character_out <= '0' & addrAux_digits(15 downto 12);
                    when 27 => addressTextRAM <= std_logic_vector(to_unsigned(744, 10)); character_out <= '0' & addrAux_digits(11 downto 8);
                    when 28 => addressTextRAM <= std_logic_vector(to_unsigned(745, 10)); character_out <= '0' & addrAux_digits(7 downto 4);
                    when 29 => addressTextRAM <= std_logic_vector(to_unsigned(746, 10)); character_out <= '0' & addrAux_digits(3 downto 0);
                    
                    when others => null;
                end case;

                if contador = 29 then
                    phase <= '1';      -- Saltamos a fase reg
                    reg_idx <= 0;
                    reg_step <= 0;
                else
                    contador <= contador + 1;
                end if;

            -- fase registros
            else
                dirReadReg <= std_logic_vector(to_unsigned(reg_idx, 4));
                
                base_addr := BASE_START + (reg_idx * ROW_OFFSET);

                if reg_step = 0 then
                    weTextRAM_n <= '1'; 
                else
                    weTextRAM_n <= '0';
                    case reg_step is
                        when 1  => addressTextRAM <= std_logic_vector(to_unsigned(base_addr + 0, 10)); character_out <= sign_dReg;
                        when 2  => addressTextRAM <= std_logic_vector(to_unsigned(base_addr + 1, 10)); character_out <= '0' & dReg_digits(39 downto 36);
                        when 3  => addressTextRAM <= std_logic_vector(to_unsigned(base_addr + 2, 10)); character_out <= '0' & dReg_digits(35 downto 32);
                        when 4  => addressTextRAM <= std_logic_vector(to_unsigned(base_addr + 3, 10)); character_out <= '0' & dReg_digits(31 downto 28);
                        when 5  => addressTextRAM <= std_logic_vector(to_unsigned(base_addr + 4, 10)); character_out <= '0' & dReg_digits(27 downto 24);
                        when 6  => addressTextRAM <= std_logic_vector(to_unsigned(base_addr + 5, 10)); character_out <= '0' & dReg_digits(23 downto 20);
                        when 7  => addressTextRAM <= std_logic_vector(to_unsigned(base_addr + 6, 10)); character_out <= '0' & dReg_digits(19 downto 16);
                        when 8  => addressTextRAM <= std_logic_vector(to_unsigned(base_addr + 7, 10)); character_out <= '0' & dReg_digits(15 downto 12);
                        when 9  => addressTextRAM <= std_logic_vector(to_unsigned(base_addr + 8, 10)); character_out <= '0' & dReg_digits(11 downto 8);
                        when 10 => addressTextRAM <= std_logic_vector(to_unsigned(base_addr + 9, 10)); character_out <= '0' & dReg_digits(7 downto 4);
                        when 11 => addressTextRAM <= std_logic_vector(to_unsigned(base_addr + 10, 10)); character_out <= '0' & dReg_digits(3 downto 0);
                        
                        when others => weTextRAM_n <= '1';
                    end case;
                end if;
                
                if reg_step = 12 then
                    reg_step <= 0;
                    if reg_idx = 15 then
                        phase <= '0'; -- Volvemos a la RAM
                        contador <= 0;
                    else
                        reg_idx <= reg_idx + 1; -- Siguiente registro
                    end if;
                else
                    reg_step <= reg_step + 1;
                end if;
                
            end if;
        end if;
    end process;

end Behavioral;





--testBench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity testDecToDigit is
end entity;

architecture testandoDecToDigit of testDecToDigit is

    signal clk             : std_logic := '0';
    
    signal dRAM_digits     : std_logic_vector(39 downto 0) := (others => '0');
    signal sign_sRAM       : std_logic_vector(4 downto 0)  := (others => '0');
    
    signal addrRAM_digits  : std_logic_vector(15 downto 0) := (others => '0'); 
    
    signal dAux_digits     : std_logic_vector(39 downto 0) := (others => '0');
    signal sign_dAux       : std_logic_vector(4 downto 0)  := (others => '0');
    
    signal addrAux_digits  : std_logic_vector(15 downto 0) := (others => '0'); 
    
    -- NUEVAS Señales para los registros
    signal dirReadReg      : std_logic_vector(3 downto 0)  := (others => '0');
    signal sign_dReg       : std_logic_vector(4 downto 0)  := (others => '0');
    signal dReg_digits     : std_logic_vector(39 downto 0) := (others => '0');
    
    signal weTextRAM_n     : std_logic;
    signal addressTextRAM  : std_logic_vector(9 downto 0);
    signal character_out   : std_logic_vector(4 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    DecToDigit_use: entity work.DecToDigit(Behavioral)
        port map (
            clk             => clk,
            dRAM_digits     => dRAM_digits,
            sign_sRAM       => sign_sRAM,
            addrRAM_digits  => addrRAM_digits,
            dAux_digits     => dAux_digits,
            sign_dAux       => sign_dAux,
            addrAux_digits  => addrAux_digits,
            weTextRAM_n     => weTextRAM_n,
            addressTextRAM  => addressTextRAM,
            character_out   => character_out,
            -- NUEVAS Conexiones de los registros
            dirReadReg      => dirReadReg,
            sign_dReg       => sign_dReg,
            dReg_digits     => dReg_digits
        );

    clk_process :process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    process
    begin
                
        -- dRAM: BCD del 0 al 9
        dRAM_digits    <= x"0123456789"; 
        sign_sRAM      <= "10100"; -- Signo +
        
        -- addrRAM: Máximo teórico para 10 bits de TextRAM (1023)
        addrRAM_digits <= x"1023"; 
        
        -- dAux: Patrón
        dAux_digits    <= x"5555555555";
        sign_dAux      <= "10011"; -- Signo -
        
        -- addrAux: Dirección aleatoria (0767, última posición TextRAM)
        addrAux_digits <= x"0767"; 

        -- dReg: Inyectamos un valor de prueba para ver si el barrido lo pinta
        sign_dReg      <= "10100"; -- Signo +
        dReg_digits    <= x"0000123456"; -- 123456 en BCD

        -- Esperar más del tiempo total del ciclo
        wait for 800 ns;

        -- Vuelta del bucle, verificar que actualiza memoria correctamente
        dRAM_digits    <= x"9999999999"; 
        addrRAM_digits <= x"0042";
        
        wait for 800 ns;

        wait;
    end process;

end architecture;