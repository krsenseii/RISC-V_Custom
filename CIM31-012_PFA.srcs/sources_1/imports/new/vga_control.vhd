----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.06.2026 11:47:38
-- Design Name: 
-- Module Name: vga_control - Behavioral
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

entity vga_control is
    Port (
        clk         : in  STD_LOGIC;  -- 100 MHz
        btn_reset_n : in  STD_LOGIC;  -- reset activo a '0'
        rom_bit     : in  std_logic;

        text_addr_r  : out std_logic_vector(9 downto 0);
        rom_col      : out integer range 0 to 19;
        rom_fila     : out integer range 0 to 19;

        vgaRed      : out STD_LOGIC_VECTOR(3 downto 0);
        vgaGreen    : out STD_LOGIC_VECTOR(3 downto 0);
        vgaBlue     : out STD_LOGIC_VECTOR(3 downto 0);
        Hsync       : out STD_LOGIC;
        Vsync       : out STD_LOGIC
    );
end vga_control;

architecture Behavioral of vga_control is

    constant H_TOTAL   : integer := 800;
    constant H_VISIBLE : integer := 640;
    constant H_FP      : integer := 16;
    constant H_SYNC    : integer := 96;

    constant V_TOTAL   : integer := 525;
    constant V_VISIBLE : integer := 480;
    constant V_FP      : integer := 10;
    constant V_SYNC    : integer := 2;

    signal clk_25 : STD_LOGIC := '0';
    signal div    : integer range 0 to 1 := 0;

    signal hc : integer range 0 to H_TOTAL-1 := 0;
    signal vc : integer range 0 to V_TOTAL-1 := 0;
    
    --posicion dentro del caracter
    signal pix_col  : integer range 0 to 19 := 0;
    signal pix_fila : integer range 0 to 19 := 0;

    --celda de la pantalla
    signal cell_x : integer range 0 to 31 := 0;
    signal cell_y : integer range 0 to 23 := 0;

    signal visible : STD_LOGIC := '0';

begin

    -- Divisor 100 MHz -> 25 MHz
    process(clk, btn_reset_n)
    begin
        if btn_reset_n = '0' then
            div    <= 0;
            clk_25 <= '0';
        elsif rising_edge(clk) then
            if div = 1 then
                div    <= 0;
                clk_25 <= not clk_25;
            else
                div <= div + 1;
            end if;
        end if;
    end process;

    process(clk_25, btn_reset_n)
    begin
        if btn_reset_n = '0' then
            hc       <= 0;
            vc       <= 0;
            pix_col  <= 0;
            pix_fila <= 0;
            cell_x   <= 0;
            cell_y   <= 0;
            
        elsif rising_edge(clk_25) then

            if hc = H_TOTAL - 1 then
                hc <= 0;
                pix_col <= 0;
                cell_x  <= 0;

                if vc = V_TOTAL - 1 then
                    vc <= 0;
                    pix_fila <= 0;
                    cell_y   <= 0;
                else
                    vc <= vc + 1;

                    if vc < V_VISIBLE then
                        if pix_fila = 19 then
                            pix_fila <= 0;
                            if cell_y = 23 then
                                cell_y <= 0;
                            else
                                cell_y <= cell_y + 1;
                            end if;
                        else
                            pix_fila <= pix_fila + 1;
                        end if;
                    end if;
                end if;

            else
                hc <= hc + 1;

                if hc < H_VISIBLE then
                    if pix_col = 19 then
                        pix_col <= 0;
                        if cell_x = 31 then
                            cell_x <= 0;
                        else
                            cell_x <= cell_x + 1;
                        end if;
                    else
                        pix_col <= pix_col + 1;
                    end if;
                end if;
            end if;

        end if;
    end process;

    -- Sync y zona visible
    Hsync   <= '0' when (hc >= H_VISIBLE + H_FP and hc < H_VISIBLE + H_FP + H_SYNC) else '1';
    Vsync   <= '0' when (vc >= V_VISIBLE + V_FP and vc < V_VISIBLE + V_FP + V_SYNC) else '1';
    visible <= '1' when (hc < H_VISIBLE and vc < V_VISIBLE) else '0';

    rom_col  <= pix_col;
    rom_fila <= pix_fila;

    text_addr_r <= std_logic_vector(to_unsigned((cell_y * 32) + cell_x, 10));

    -- Color
    process(visible, rom_bit)
    begin
        if visible = '0' then
            vgaRed   <= "0000";
            vgaGreen <= "0000";
            vgaBlue  <= "0000";
        else
            if rom_bit = '1' then
                vgaRed   <= "1111";
                vgaGreen <= "1111";
                vgaBlue  <= "1111";
            else
                vgaRed   <= "0000";
                vgaGreen <= "0000";
                vgaBlue  <= "0000";
            end if;
        end if;
    end process;

end Behavioral;






--testBench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- testBench
entity testvga_control is
end entity;

architecture testeandovga_control of testvga_control is

    signal clk         : STD_LOGIC := '0';
    signal btn_reset_n : STD_LOGIC := '0';
    signal rom_bit     : STD_LOGIC := '0';

    signal rom_col     : integer range 0 to 19;
    signal rom_fila    : integer range 0 to 19;
    signal vgaRed      : STD_LOGIC_VECTOR(3 downto 0);
    signal vgaGreen    : STD_LOGIC_VECTOR(3 downto 0);
    signal vgaBlue     : STD_LOGIC_VECTOR(3 downto 0);
    signal Hsync       : STD_LOGIC;
    signal Vsync       : STD_LOGIC;

    constant CLK_PERIOD : time := 10 ns;

begin

    vga_control_use: entity work.vga_control(Behavioral)
        port map (
            clk         => clk,
            btn_reset_n => btn_reset_n,
            rom_bit     => rom_bit,
            rom_col     => rom_col,
            rom_fila    => rom_fila,
            vgaRed      => vgaRed,
            vgaGreen    => vgaGreen,
            vgaBlue     => vgaBlue,
            Hsync       => Hsync,
            Vsync       => Vsync
        );

    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Esta lógica cambia el bit de la ROM simulada cada cierto tiempo
    -- para ver cómo cambian los colores en pantalla de blanco a negro.
    rom_proc: process
    begin
        while true loop
            rom_bit <= '1';
            wait for 80 ns; -- cada píxel son 40ns
            rom_bit <= '0';
            wait for 80 ns;
        end loop;
    end process;

    process
    begin
        btn_reset_n <= '0';
        wait for 100 ns;
        
        btn_reset_n <= '1';
        
        wait for 17 ms;

        wait;
    end process;

end architecture;
