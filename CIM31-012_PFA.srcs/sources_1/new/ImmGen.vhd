----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.04.2026 16:50:10
-- Design Name: 
-- Module Name: ImmGen - Behavioral
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

entity ImmGen is
    port(
        instrIn : in  std_logic_vector(31 downto 0);
        ImmSel      : in  std_logic_vector(2 downto 0); 
        immOut   : out std_logic_vector(31 downto 0)
    );
end ImmGen;

architecture Behavioral of ImmGen is
 signal tipoIEspecial : std_logic_vector (9 downto 0);
begin

    process(instrIn, ImmSel)
        variable tmp_b, tmp_j : signed(31 downto 0);
      
        
    begin
     tipoIEspecial <= instrIn(14 downto 12) & instrIn(6 downto 0);
        case ImmSel is

            -- "000" S-type -> extensión de signo
            when "000" =>
                immOut <= (31 downto 12 => instrIn(31)) & 
                             instrIn(31 downto 25) & 
                             instrIn(11 downto 7);

            -- "001" I-type -> extensión de signo
            when "001" =>
                    case tipoIEspecial is
                        when "0010010011" | "1010010011" => 
                            immOut <= (31 downto 5 => '0') & instrIn(24 downto 20);
                            
                when others =>
                immOut <= (31 downto 12 => instrIn(31)) & 
                             instrIn(31 downto 20);
                end case;
            -- "010" B-type -> desplazamiento 2bits
            -- estándar RISC-V [12:1]; [0] = '0' de forma implicita
            -- al ir con PC +1 y no direccionamos de 4 en 4 con bloques de 8 bits sino de 1 en 1 en bloques de 32 bits
            -- por ello debemos dividir /4
            when "010" =>
                tmp_b := signed((31 downto 13 => instrIn(31)) & 
                                instrIn(31) & instrIn(7) & 
                                instrIn(30 downto 25) & instrIn(11 downto 8) & '0');
                immOut <= std_logic_vector(shift_right(tmp_b, 2));

            -- "011" J-type -> desplazamiento 2bits (mismo caso que antes)
            when "011" =>
                tmp_j := signed((31 downto 21 => instrIn(31)) & 
                                instrIn(31) & instrIn(19 downto 12) & 
                                instrIn(20) & instrIn(30 downto 21) & '0');
                immOut <= std_logic_vector(shift_right(tmp_j, 2));

            -- "100" U-type -> 20 bits a la parte alta, rellena con '0's abajo
            when "100" =>
                immOut <= instrIn(31 downto 12) & x"000";
                
            -- others
            when others =>
                immOut <= x"00000000";

        end case;
    end process;

end Behavioral;






-- testBench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity testImmGen is
end entity;

architecture testeandoImmGen of testImmGen is
    signal instrIn : std_logic_vector(31 downto 0) := (others => '0');
    signal ImmSel      : std_logic_vector(2 downto 0) := "111";
    signal immOut    : std_logic_vector(31 downto 0);
begin

    ImmGen_use: entity work.ImmGen(Behavioral)
        port map(
            instrIn => instrIn,
            ImmSel => ImmSel,
            immOut => immOut
        );

    instrIn <=
        x"00302123" after 0 ns,    -- S-type: sw x3, 2(x0)      -> imm = 2
        x"00A00093" after 20 ns,   -- I-type: addi x1, x0, 10   -> imm = 10
        x"FE000EE3" after 40 ns,   -- B-type: beq x0,x0,-4      -> imm = -1
        x"0080006F" after 60 ns,   -- J-type: jal x0, 8         -> imm = 2
        x"123450B7" after 80 ns,   -- U-type: lui x1, 0x12345   -> imm = 0x12345000
        x"002081B3" after 100 ns;  -- R-type: add x3, x1, x2    -> imm = 0

    ImmSel <=
        "000" after 0 ns,   -- S
        "001" after 20 ns,  -- I
        "010" after 40 ns,  -- B
        "011" after 60 ns,  -- J
        "100" after 80 ns,  -- U
        "111" after 100 ns; -- others

end architecture testeandoImmGen;