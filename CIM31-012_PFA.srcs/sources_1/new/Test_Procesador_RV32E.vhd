library IEEE;

use IEEE.STD_LOGIC_1164.ALL;



entity Test_Procesador_RV32E is

end Test_Procesador_RV32E;



architecture Behavioral of Test_Procesador_RV32E is

    signal s_clk   : std_logic := '0';

    signal s_reset : std_logic := '0';

    

    constant clk_period : time := 10 ns;

begin 

 

    Procesador_RV32E_use: entity work.Procesador_RV32E(Structural)

        port map (

            clk   => s_clk,

            reset => s_reset

        );



 

    clk_process: process

    begin

        s_clk <= '0'; wait for clk_period/2;

        s_clk <= '1'; wait for clk_period/2;

    end process;



    stim_proc: process

    begin

        s_reset <= '0'; 

        wait for 20 ns;

        s_reset <= '1';

        wait;

    end process;

end Behavioral;