----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.04.2026 12:13:03
-- Design Name: 
-- Module Name: CP - Behavioral
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

entity CP is
    port(
        clk, resetCP: in std_logic;
        CPsel: in std_logic_vector(1 downto 0);
        offset: in std_logic_vector(31 downto 0);
        rs1: in std_logic_vector(31 downto 0);
        ImmSel : in  std_logic_vector(2 downto 0); 
        CPout: out std_logic_vector(31 downto 0)
    );
end CP;

architecture Estructural of CP is
    signal R32in           : std_logic_vector(31 downto 0);
    signal CPSum1out       : std_logic_vector(31 downto 0);
    signal R32out          : std_logic_vector(31 downto 0);
    signal CPOffsetOut     : std_logic_vector(31 downto 0);
    signal Rs1SumOffsetOut  : std_logic_vector(31 downto 0); 
begin
    R32_use: entity work.R32(Estructural)
        port map(
            clk => clk, reset => resetCP, WriteEnable => '0', R32in => R32in, R32out => R32out
        );

    Sum1CP_use: entity work.Sum1CP(Behavioral)
        port map(
            CPin => R32out, CPout => CPSum1out
        );
        
    SumPCOffset_use: entity work.SumPCOffset(Behavioral)
        port map(
            CPin => R32out, offset => offset, CPOffsetOut => CPOffsetOut
        );
        
    rs1SumOffset_use: entity work.rs1SumOffset(Behavioral)
        port map(
            rs1 => rs1, offset => offset, Rs1SumOffsetOut => Rs1SumOffsetOut 
        );
        
    MUX2_use: entity work.MUX2(FlujoDatos)
        port map(
            PCSum1    => CPSum1out, 
            PCOffset  => CPOffsetOut, 
            Rs1Offset => Rs1SumOffsetOut, 
            PC        => R32out,          
            MUXsel    => CPsel, 
            MUXout    => R32in
        );
        
    CPout <= R32out;
end Estructural;







-- testBench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity testCP is
end entity;

architecture testeandoCP of testCP is
    signal clk     : std_logic := '0';
    signal CPsel   : std_logic_vector(1 downto 0) := "00"; 
    signal resetCP : std_logic := '1'; 
    signal offset  : std_logic_vector(31 downto 0) := (others => '0');
    signal rs1     : std_logic_vector(31 downto 0) := (others => '0'); 
    signal ImmSel  : std_logic_vector(2 downto 0) := "000";         
    signal CPout   : std_logic_vector(31 downto 0);
    
begin
    CP_use: entity work.CP(Estructural)
        port map(
            clk     => clk,
            CPsel   => CPsel,
            resetCP => resetCP,
            offset  => offset,
            rs1     => rs1,    
            ImmSel  => ImmSel,  
            CPout   => CPout
        );

   process
    begin
        clk <= '0'; wait for 5 ns;
        clk <= '1'; wait for 5 ns;
    end process;

    resetCP <= '0' after 0 ns, '1' after 15 ns;

    CPsel <= "00" after 0 ns,   
             "01" after 55 ns,  
             "10" after 85 ns,  
             "11" after 115 ns; 
             
    offset <= X"0000000A" after 45 ns; 
    rs1    <= X"00000020" after 75 ns; 
    
end architecture;