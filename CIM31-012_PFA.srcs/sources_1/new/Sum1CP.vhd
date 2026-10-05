


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Sum1CP is
    Port(
        CPin  : in  std_logic_vector(31 downto 0);
        CPout : out std_logic_vector(31 downto 0)
    );
end Sum1CP;

architecture Behavioral of Sum1CP is
begin

    CPout <= std_logic_vector(unsigned(CPin) + 1);

end Behavioral;
