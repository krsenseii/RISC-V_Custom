----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.04.2026 11:36:11
-- Design Name: 
-- Module Name: div1hz - Behavioral
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

entity div1hz is
 port (
    clockInput: in std_logic;
    clk1Hz: out std_logic
 );
end div1hz;

architecture Behavioral of div1hz is
    signal tempClk1Hz: std_logic:= '0';
    signal contador : INTEGER RANGE 0 to 49999999 := 0;
begin

    process(clockInput)
        
    begin
        if rising_edge(clockInput)then
            if(contador = 49999999) then
                contador<= 0;
                tempClk1Hz <= not tempClk1Hz;
            else
                contador<= contador + 1;
            end if;
        end if;
    end process;
    
    clk1Hz <= tempClk1Hz;

end Behavioral;





