----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.05.2026 16:26:56
-- Design Name: 
-- Module Name: Bank_R32 - Estructural
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

entity Bank_R32 is
    Port (
        D            : in std_logic_vector (31 downto 0);
        Reset        : in std_logic; -- activo a baja
        Escritura    : in std_logic; -- activo a baja
        SelectorEsc  : in std_logic_vector(3 downto 0);
        SelectorLec0 : in std_logic_vector (3 downto 0);
        SelectorLec1 : in std_logic_vector (3 downto 0);     
        Clk          : in std_logic;            
        Q0, Q1       : out std_logic_vector (31 downto 0);
        
        x0_display  : out std_logic_vector(31 downto 0);
        x1_display  : out std_logic_vector(31 downto 0);
        x2_display  : out std_logic_vector(31 downto 0);
        x3_display  : out std_logic_vector(31 downto 0);
        x4_display  : out std_logic_vector(31 downto 0);
        x5_display  : out std_logic_vector(31 downto 0);
        x6_display  : out std_logic_vector(31 downto 0);
        x7_display  : out std_logic_vector(31 downto 0);
        x8_display  : out std_logic_vector(31 downto 0);
        x9_display  : out std_logic_vector(31 downto 0);
        x10_display : out std_logic_vector(31 downto 0);
        x11_display : out std_logic_vector(31 downto 0);
        x12_display : out std_logic_vector(31 downto 0);
        x13_display : out std_logic_vector(31 downto 0);
        x14_display : out std_logic_vector(31 downto 0);
        x15_display : out std_logic_vector(31 downto 0)
    );
end Bank_R32;

architecture Structural of Bank_R32 is
    signal WriteEnable_s : std_logic_vector(15 downto 0);
    
    type array_reg is array (0 to 15) of std_logic_vector(31 downto 0);
    signal s_regs : array_reg;
begin

    Decoder4_16_use: entity work.Decoder4_16(Behavioral)
        port map (
            Entrada => SelectorEsc,
            Enable  => Escritura,
            Salida  => WriteEnable_s
        );

    ciclo_regs: for i in 0 to 15 generate
        R32_0: if i = 0 generate
            s_regs(0) <= X"00000000"; -- registro 0 siempre es 0
        end generate;

        R32_n: if i > 0 generate
            bank: entity work.R32(Estructural)
                port map (
                    clk         => Clk,
                    reset       => Reset,
                    WriteEnable => WriteEnable_s(i), 
                    R32in       => D,
                    R32out      => s_regs(i)
                );
        end generate;
    end generate;

    Q0 <= s_regs(to_integer(unsigned(SelectorLec0)));
    Q1 <= s_regs(to_integer(unsigned(SelectorLec1)));




        x0_display  <= s_regs(0);
        x1_display  <= s_regs(1);
        x2_display  <= s_regs(2);
        x3_display  <= s_regs(3);
        x4_display  <= s_regs(4);
        x5_display  <= s_regs(5);
        x6_display  <= s_regs(6);
        x7_display  <= s_regs(7);
        x8_display  <= s_regs(8);
        x9_display  <= s_regs(9);
        x10_display  <= s_regs(10);
        x11_display  <= s_regs(11);
        x12_display  <= s_regs(12);
        x13_display  <= s_regs(13);
        x14_display  <= s_regs(14);
        x15_display  <= s_regs(15);

        
end Structural;






--testBench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity testBank_R32 is
end entity;

architecture tb of testBank_R32 is
    signal D, Q0, Q1 : std_logic_vector(31 downto 0);
    signal Reset, Escritura, Clk : std_logic := '1';
    signal SelE, SelL0, SelL1 : std_logic_vector(3 downto 0) := "0000";
    
begin
    Bank_R32_use: entity work.Bank_R32(Structural)
        port map(
            D            => D,
            Reset        => Reset,
            Escritura    => Escritura,
            SelectorEsc  => SelE,
            SelectorLec0 => SelL0,
            SelectorLec1 => SelL1,
            Clk          => Clk,
            Q0           => Q0,
            Q1           => Q1
        );

    process
    begin
        while true loop
            Clk <= '0'; wait for 5 ns;
            Clk <= '1'; wait for 5 ns;
        end loop;
    end process;

    process
    begin
        Reset <= '0'; Escritura <= '1';
        wait for 12 ns;
        Reset <= '1';

        wait until rising_edge(Clk);

        D         <= X"ABCDEF12";
        SelE      <= "0001";
        Escritura <= '0';
        
        wait until rising_edge(Clk);
        Escritura <= '1';

        SelL0 <= "0001"; 
        SelL1 <= "0000";
        wait for 20 ns;

        SelL0 <= "0000"; 
        SelL1 <= "0001";
        wait for 20 ns;

        SelL0 <= "0001";
        SelL1 <= "0001"; 
        wait for 20 ns;

        wait;
    end process;
    
end architecture;