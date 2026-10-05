----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.06.2026 12:31:57
-- Design Name: 
-- Module Name: BinToDec - Behavioral
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

entity BinToDec is
    port(
        dRAM    : in std_logic_vector(31 downto 0);
        addrRAM : in std_logic_vector(9 downto 0);
        dAux    : in std_logic_vector(31 downto 0);
        addrAux : in std_logic_vector(9 downto 0);
        
        dReg            : in std_logic_vector(31 downto 0); 
        
        sign_dRAM       : out std_logic_vector(4 downto 0);
        dRAM_digits     : out std_logic_vector(39 downto 0);
        addrRAM_digits  : out std_logic_vector(15 downto 0);
        
        sign_dAux       : out std_logic_vector(4 downto 0);
        dAux_digits     : out std_logic_vector(39 downto 0);
        addrAux_digits  : out std_logic_vector(15 downto 0);
        
        sign_dReg       : out std_logic_vector(4 downto 0);
        dReg_digits     : out std_logic_vector(39 downto 0)
    );
end BinToDec;

architecture Behavioral of BinToDec is
begin

    -- PROCESO dRAM
    process(dRAM)
        variable magnitude : unsigned(31 downto 0);
        variable shift_reg : unsigned(71 downto 0); 
        variable bcd_digit : unsigned(3 downto 0);
    begin
        -- Evaluación de signo y Complemento a 2
        if dRAM(31) = '1' then
            sign_dRAM <= "10011"; -- Signo Negativo (-)
            magnitude := unsigned(not dRAM) + 1;
        else
            sign_dRAM <= "10100"; -- Signo Positivo (+)
            magnitude := unsigned(dRAM);
        end if;

        shift_reg := (others => '0');
        shift_reg(31 downto 0) := magnitude;

        for i in 0 to 31 loop
            for j in 0 to 9 loop
                bcd_digit := shift_reg(32 + (j*4) + 3 downto 32 + (j*4));
                if bcd_digit >= 5 then
                    bcd_digit := bcd_digit + 3;
                end if;
                shift_reg(32 + (j*4) + 3 downto 32 + (j*4)) := bcd_digit;
            end loop;
            shift_reg := shift_reg(70 downto 0) & '0';
        end loop;
        
        dRAM_digits <= std_logic_vector(shift_reg(71 downto 32));
    end process;

    -- PROCESO addrRAM
    process(addrRAM)
        variable shift_reg : unsigned(25 downto 0); 
        variable bcd_digit : unsigned(3 downto 0);
    begin
        shift_reg := (others => '0');
        shift_reg(9 downto 0) := unsigned(addrRAM);

        for i in 0 to 9 loop -- Solo 10 desplazamientos
            for j in 0 to 3 loop -- Solo 4 dígitos BCD
                bcd_digit := shift_reg(10 + (j*4) + 3 downto 10 + (j*4));
                if bcd_digit >= 5 then
                    bcd_digit := bcd_digit + 3;
                end if;
                shift_reg(10 + (j*4) + 3 downto 10 + (j*4)) := bcd_digit;
            end loop;
            shift_reg := shift_reg(24 downto 0) & '0';
        end loop;
        
        addrRAM_digits <= std_logic_vector(shift_reg(25 downto 10));
    end process;

    -- PROCESO dAux
    process(dAux)
        variable magnitude : unsigned(31 downto 0);
        variable shift_reg : unsigned(71 downto 0); 
        variable bcd_digit : unsigned(3 downto 0);
    begin
        -- Evaluación de signo y Complemento a 2
        if dAux(31) = '1' then
            sign_dAux <= "10011"; -- Signo Negativo (-)
            magnitude := unsigned(not dAux) + 1;
        else
            sign_dAux <= "10100"; -- Signo Positivo (+)
            magnitude := unsigned(dAux);
        end if;

        shift_reg := (others => '0');
        shift_reg(31 downto 0) := magnitude;

        for i in 0 to 31 loop
            for j in 0 to 9 loop
                bcd_digit := shift_reg(32 + (j*4) + 3 downto 32 + (j*4));
                if bcd_digit >= 5 then
                    bcd_digit := bcd_digit + 3;
                end if;
                shift_reg(32 + (j*4) + 3 downto 32 + (j*4)) := bcd_digit;
            end loop;
            shift_reg := shift_reg(70 downto 0) & '0';
        end loop;
        
        dAux_digits <= std_logic_vector(shift_reg(71 downto 32));
    end process;

    -- PROCESO addrAux
    process(addrAux)
        variable shift_reg : unsigned(25 downto 0); 
        variable bcd_digit : unsigned(3 downto 0);
    begin
        shift_reg := (others => '0');
        shift_reg(9 downto 0) := unsigned(addrAux);

        for i in 0 to 9 loop
            for j in 0 to 3 loop
                bcd_digit := shift_reg(10 + (j*4) + 3 downto 10 + (j*4));
                if bcd_digit >= 5 then
                    bcd_digit := bcd_digit + 3;
                end if;
                shift_reg(10 + (j*4) + 3 downto 10 + (j*4)) := bcd_digit;
            end loop;
            shift_reg := shift_reg(24 downto 0) & '0';
        end loop;
        
        addrAux_digits <= std_logic_vector(shift_reg(25 downto 10));
    end process;
    
    -- PROCESO dReg
   process(dReg)
        variable magnitude : unsigned(31 downto 0);
        variable shift_reg : unsigned(71 downto 0); 
        variable bcd_digit : unsigned(3 downto 0);
    begin
        if dReg(31) = '1' then
            sign_dReg <= "10011"; -- Signo Negativo (-)
            magnitude := unsigned(not dReg) + 1;
        else
            sign_dReg <= "10100"; -- Signo Positivo (+)
            magnitude := unsigned(dReg);
        end if;

        shift_reg := (others => '0');
        shift_reg(31 downto 0) := magnitude;

        for i in 0 to 31 loop
            for j in 0 to 9 loop
                bcd_digit := shift_reg(32 + (j*4) + 3 downto 32 + (j*4));
                if bcd_digit >= 5 then bcd_digit := bcd_digit + 3; end if;
                shift_reg(32 + (j*4) + 3 downto 32 + (j*4)) := bcd_digit;
            end loop;
            shift_reg := shift_reg(70 downto 0) & '0';
        end loop;
        dReg_digits <= std_logic_vector(shift_reg(71 downto 32));
    end process;
    

end Behavioral;








-- testBench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity testBinToDec is
end entity;

architecture testeandoBinToDec of testBinToDec is

    signal dRAM    : std_logic_vector(31 downto 0) := (others => '0');
    signal addrRAM : std_logic_vector(9 downto 0)  := (others => '0');
    signal dAux    : std_logic_vector(31 downto 0) := (others => '0');
    signal addrAux : std_logic_vector(9 downto 0)  := (others => '0');

    -- Añadimos las señales de los registros
    signal dReg            : std_logic_vector(31 downto 0) := (others => '0');

    signal dRAM_digits     : std_logic_vector(39 downto 0);
    signal sign_dRAM       : std_logic_vector(4 downto 0);
    signal addrRAM_digits  : std_logic_vector(15 downto 0);
    signal dAux_digits     : std_logic_vector(39 downto 0);
    signal sign_dAux       : std_logic_vector(4 downto 0);
    signal addrAux_digits  : std_logic_vector(15 downto 0);
    
    -- Añadimos las salidas de los registros
    signal sign_dReg       : std_logic_vector(4 downto 0);
    signal dReg_digits     : std_logic_vector(39 downto 0);

begin

    BinToDec_use: entity work.BinToDec(Behavioral)
        port map (
            dRAM           => dRAM,
            addrRAM        => addrRAM,
            dAux           => dAux,
            addrAux        => addrAux,
            dReg           => dReg,         
            dRAM_digits    => dRAM_digits,
            sign_dRAM      => sign_dRAM,
            addrRAM_digits => addrRAM_digits,
            dAux_digits    => dAux_digits,
            sign_dAux      => sign_dAux,
            addrAux_digits => addrAux_digits,
            sign_dReg      => sign_dReg,     
            dReg_digits    => dReg_digits    
        );

    process
    begin
        -- Todo a 0
        dRAM    <= std_logic_vector(to_signed(0, 32));
        addrRAM <= std_logic_vector(to_unsigned(0, 10));
        dAux    <= std_logic_vector(to_signed(0, 32));
        addrAux <= std_logic_vector(to_unsigned(0, 10));
        dReg    <= std_logic_vector(to_signed(0, 32)); -- Inicializamos
        wait for 50 ns;

        -- Valores estándar
        dRAM    <= std_logic_vector(to_signed(5, 32));
        addrRAM <= std_logic_vector(to_unsigned(42, 10));
        dAux    <= std_logic_vector(to_signed(255, 32));
        addrAux <= std_logic_vector(to_unsigned(767, 10));
        dReg    <= std_logic_vector(to_signed(1234, 32)); -- Probamos el registro
        wait for 50 ns;

        -- Datos Negativos / Direcciones altas
        dRAM    <= std_logic_vector(to_signed(-1, 32));
        addrRAM <= std_logic_vector(to_unsigned(704, 10));
        dAux    <= std_logic_vector(to_signed(-42, 32));
        addrAux <= std_logic_vector(to_unsigned(1023, 10));
        dReg    <= std_logic_vector(to_signed(-5678, 32)); -- Probamos negativo
        wait for 50 ns;

        -- Valores Extremos de datos
        dRAM    <= std_logic_vector(to_signed(2147483647, 32));
        addrRAM <= std_logic_vector(to_unsigned(123, 10));
        dAux    <= std_logic_vector(to_signed(-2147483648, 32));
        addrAux <= std_logic_vector(to_unsigned(456, 10));
        dReg    <= std_logic_vector(to_signed(2147483647, 32));
        wait for 50 ns;

        wait;
    end process;

end architecture;