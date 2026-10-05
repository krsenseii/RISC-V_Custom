
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rs1SumOffset is
    port(
        rs1, offset    : in  std_logic_vector(31 downto 0);
        Rs1SumOffsetOut    : out std_logic_vector(31 downto 0)
    );
end rs1SumOffset;

architecture Behavioral of rs1SumOffset is
begin
        Rs1SumOffsetOut <= std_logic_vector(signed(rs1) + signed(offset));
end Behavioral;
