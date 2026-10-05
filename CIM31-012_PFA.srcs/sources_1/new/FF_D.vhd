----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.04.2026 12:13:50
-- Design Name: 
-- Module Name: FF_D - Behavioral
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

entity FF_D is
    port(
        D, clk, preset, clear, enable: in std_logic;
        Q, Qn: out std_logic
    );
end FF_D;

architecture Behavioral of FF_D is
    signal temp: std_logic:= '0';
begin

    process(clk, preset, clear)
    begin
        if(clear = '0')then
            temp <= '0';
        elsif(preset = '0')then
            temp <= '1';
        elsif(rising_edge(clk))then 
            if (enable = '0') then 
                temp <= D;
            end if;
        end if;
    end process;

    Q <= temp;
    Qn <= not temp;

end Behavioral;






-- testBench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity testFF_D is
end entity;

architecture testeandoFF_D of testFF_D is 
    signal D, clk, preset, clear, Q, Qn, enable: std_logic;
begin
    
    FF_D_use: entity work.FF_D(Behavioral)
        port map(
            D => D,
            clk => clk,
            preset => preset,
            clear => clear,
            enable => enable,
            Q => Q,
            Qn => Qn
          );

    process
    begin
        for i in 0 to 10 loop
             clk <= '0';
                wait for 5 ns;
             clk <= '1';
                wait for 5 ns;
        end loop;
    end process;
    
    D       <= '0' after 0 ns,  '1' after 5 ns,  '0' after 20 ns, '1' after 25 ns, '0' after 30 ns;
    preset  <= '1' after 0 ns,  '0' after 15 ns, '1' after 20 ns;
    clear   <= '1' after 0 ns,  '0' after 25 ns, '1' after 30 ns;
    enable  <= '1' after 0 ns,  '0' after 10 ns, '1' after 18 ns, '0' after 26 ns;

end architecture testeandoFF_D;


