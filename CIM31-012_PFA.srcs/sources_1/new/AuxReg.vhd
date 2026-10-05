


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AuxReg is
    port(
        clk           : in  std_logic;
        
        -- escritura 
        RegWrite_n    : in  std_logic;
        dirWrite      : in  std_logic_vector(3 downto 0);
        dataIn        : in  std_logic_vector(31 downto 0);
        
        -- lectura
        dirRead       : in  std_logic_vector(3 downto 0);
        dataOut       : out std_logic_vector(31 downto 0)
    );
end AuxReg;

architecture Behavioral of AuxReg is
    type reg_t is array (0 to 15) of std_logic_vector(31 downto 0);
    signal REGS : reg_t := (others => (others => '0'));
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if RegWrite_n = '0' and to_integer(unsigned(dirWrite)) /= 0 then -- no cambia el 0
                REGS(to_integer(unsigned(dirWrite))) <= dataIn;
            end if;
        end if;
    end process;
    
    -- Lectura asíncrona
    dataOut <= REGS(to_integer(unsigned(dirRead)));
    
end Behavioral;