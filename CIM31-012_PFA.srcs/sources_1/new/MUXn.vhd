


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX2 is
    port(
        PCSum1: in std_logic_vector(31 downto 0);
        PCOffset: in std_logic_vector(31 downto 0);
        Rs1Offset: in std_logic_vector(31 downto 0);
        PC: in std_logic_vector(31 downto 0);
        MUXsel: in std_logic_vector(1 downto 0);
        MUXout: out std_logic_vector(31 downto 0)
    );
end MUX2;

architecture FlujoDatos of MUX2 is
begin

    with MUXsel select
        MUXout <= PCSum1    when "00",
                  PCOffset  when "01",
                  Rs1Offset when "10",
                  PC        when others;


end FlujoDatos;





-- testBench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity testMUX2 is 
end entity;

architecture testeandoMUX2 of testMUX2 is
    signal PCSum1    : std_logic_vector(31 downto 0);
    signal PCOffset  : std_logic_vector(31 downto 0);
    signal Rs1Offset : std_logic_vector(31 downto 0);
    signal PC_actual : std_logic_vector(31 downto 0);
    signal MUXsel    : std_logic_vector(1 downto 0) := "00";
    signal MUXout    : std_logic_vector(31 downto 0);
begin

    MUX2_use: entity work.MUX2(FlujoDatos)
        port map(
            PCSum1    => PCSum1,
            PCOffset  => PCOffset,
            Rs1Offset => Rs1Offset,
            PC        => PC_actual,
            MUXsel    => MUXsel,
            MUXout    => MUXout
        );

   
        PCSum1   <= X"00000001" after 0 ns, X"BBBBBBBB" after 5 ns; 
        PCOffset <= X"AAAAAAAA" after 0 ns; 
        Rs1Offset <= X"12345678" after 0 ns;
        PC_actual <= X"FFFFFFFF" after 0 ns;
        
         MUXsel <= "00" after 0 ns,   
                   "01" after 10 ns, 
                   "10" after 20 ns,  
                   "11" after 30 ns; 

end architecture testeandoMUX2;