----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.05.2026 18:01:55
-- Design Name: 
-- Module Name: LoadStoreUnit - Behavioral
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

entity LoadStoreUnit is
    Port (
        Funct3       : in  std_logic_vector(2 downto 0); 
        WriteEnable_n  : in  std_logic; 
        
        addr   : in  std_logic_vector(31 downto 0); 
        StoreDataIn : in  std_logic_vector(31 downto 0); 
        LoadDataOut : out std_logic_vector(31 downto 0); 
        LoadDataIn   : in  std_logic_vector(31 downto 0); 
        MemWriteOut_n: out std_logic_vector(3 downto 0); 
        StoreDataOut: out std_logic_vector(31 downto 0)  
    );
end LoadStoreUnit;

architecture Behavioral of LoadStoreUnit is
    signal byte_offset : std_logic_vector(1 downto 0);
begin
    
    byte_offset <= addr(1 downto 0);

    --store
    process(WriteEnable_n, Funct3, byte_offset, StoreDataIn)
    begin
        MemWriteOut_n <= "1111";
        StoreDataOut <= StoreDataIn; 
        
        if WriteEnable_n = '0' then
            case Funct3 is
                when "000" => -- SB
                    case byte_offset is
                        when "00" => MemWriteOut_n <= "1110"; StoreDataOut(7 downto 0)   <= StoreDataIn(7 downto 0);
                        when "01" => MemWriteOut_n <= "1101"; StoreDataOut(15 downto 8)  <= StoreDataIn(7 downto 0);
                        when "10" => MemWriteOut_n <= "1011"; StoreDataOut(23 downto 16) <= StoreDataIn(7 downto 0);
                        when "11" => MemWriteOut_n <= "0111"; StoreDataOut(31 downto 24) <= StoreDataIn(7 downto 0);
                        when others => StoreDataOut <= (others => '0');
                    end case;
                    
                when "001" => -- SH
                    case byte_offset(1) is
                        when '1' => 
                            MemWriteOut_n <= "0011"; 
                            StoreDataOut(31 downto 16) <= StoreDataIn(15 downto 0);
                        when '0' => 
                            MemWriteOut_n <= "1100";
                            StoreDataOut(15 downto 0) <= StoreDataIn(15 downto 0);
                        when others => StoreDataOut <= (others => '0');
                    end case;
                    
                when "010" => -- SW
                    MemWriteOut_n <= "0000";
                    StoreDataOut <= StoreDataIn;
                    
                when others => MemWriteOut_n <= "1111";
            end case;
        end if;
    end process;



    --load
    process(Funct3, byte_offset, LoadDataIn)
    begin

        case Funct3 is
            when "000" => -- LB 
                case byte_offset is
                    when "00" => LoadDataOut <= (31 downto 8 => LoadDataIn(7))  & LoadDataIn(7 downto 0);
                    when "01" => LoadDataOut <= (31 downto 8 => LoadDataIn(15)) & LoadDataIn(15 downto 8);
                    when "10" => LoadDataOut <= (31 downto 8 => LoadDataIn(23)) & LoadDataIn(23 downto 16);
                    when "11" => LoadDataOut <= (31 downto 8 => LoadDataIn(31)) & LoadDataIn(31 downto 24);
                    when others => LoadDataOut <= (others => '0');
                end case;
                
                
             when "001" => -- LH 
                if byte_offset(1) = '0' then
                    LoadDataOut <= (31 downto 16 => LoadDataIn(15)) & LoadDataIn(15 downto 0);
                else                         
                    LoadDataOut <= (31 downto 16 => LoadDataIn(31)) & LoadDataIn(31 downto 16);
                end if;


             when "010" => -- LW 
                 LoadDataOut <= LoadDataIn;


            when "100" => -- LBU 
                case byte_offset is
                    when "00" => LoadDataOut <= x"000000" & LoadDataIn(7 downto 0);
                    when "01" => LoadDataOut <= x"000000" & LoadDataIn(15 downto 8);
                    when "10" => LoadDataOut <= x"000000" & LoadDataIn(23 downto 16);
                    when "11" => LoadDataOut <= x"000000" & LoadDataIn(31 downto 24);
                    when others => LoadDataOut <= (others => '0');
                end case;


            when "101" => -- LHU 
                if byte_offset(1) = '0' then
                    LoadDataOut <= x"0000" & LoadDataIn(15 downto 0);
                else
                    LoadDataOut <= x"0000" & LoadDataIn(31 downto 16);
                end if;


            when others =>
                LoadDataOut <= LoadDataIn;
        end case;
    end process;

end Behavioral;







--testBench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity testLSU is
end entity;

architecture testeandoLSU of testLSU is
    signal Funct3        : std_logic_vector(2 downto 0) := "000";
    signal WriteEnable_n   : std_logic := '1';

    signal addr          : std_logic_vector(31 downto 0) := (others => '0');
    signal StoreDataIn   : std_logic_vector(31 downto 0) := (others => '0');
    signal LoadDataOut   : std_logic_vector(31 downto 0);
    signal LoadDataIn    : std_logic_vector(31 downto 0) := (others => '0');
    signal MemWriteOut_n : std_logic_vector(3 downto 0);
    signal StoreDataOut  : std_logic_vector(31 downto 0);

begin

    LSU_use: entity work.LoadStoreUnit(Behavioral)
        port map(
            Funct3        => Funct3,
            WriteEnable_n   => WriteEnable_n,
            addr          => addr,
            StoreDataIn   => StoreDataIn,
            LoadDataOut   => LoadDataOut,
            LoadDataIn    => LoadDataIn,
            MemWriteOut_n => MemWriteOut_n,
            StoreDataOut  => StoreDataOut
        );

    process
    begin

        -- t = 0 
        Funct3      <= "000";
        WriteEnable_n <= '1';
        addr        <= x"00000000";
        StoreDataIn <= x"00000000";
        LoadDataIn  <= x"00000000";


        wait for 10 ns;
        -- t = 10 
        -- SB  00
        Funct3      <= "000";
        WriteEnable_n <= '0';
        addr        <= x"00000000";
        StoreDataIn <= x"0000DCAB";


        wait for 10 ns;
        -- t = 20 
        -- SB  01
        addr <= x"00000001";


        wait for 10 ns;
        -- t = 30 
        -- SH bajo
        Funct3      <= "001";
        addr        <= x"00000000";
        StoreDataIn <= x"0000BEEF";


        wait for 10 ns;
        -- t = 40 
        -- SH alto
        addr <= x"00000002";


        wait for 10 ns;
        -- t = 50 
        -- SW
        Funct3      <= "010";
        addr        <= x"00000000";
        StoreDataIn <= x"DEADBEEF";


        wait for 10 ns;
        -- t = 60 
        -- LB
        WriteEnable_n <= '1';
        Funct3      <= "000";
        addr        <= x"00000000";
        LoadDataIn  <= x"11223380";


        wait for 10 ns;
        -- t = 70 
        -- LBU
        Funct3 <= "100";


        wait for 10 ns;
        -- t = 80 
        -- LH 
        Funct3 <= "001";
        LoadDataIn <= x"00008001";


        wait for 10 ns;
        -- t = 90 
        -- LHU
        Funct3 <= "101";

        wait for 10 ns;
        -- t = 100 
        -- LW
        Funct3 <= "010";
        LoadDataIn <= x"CAFEBABE";


        wait;

    end process;

end architecture;