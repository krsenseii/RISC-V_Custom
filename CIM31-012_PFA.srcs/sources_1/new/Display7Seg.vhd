library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity display is
    Port(
        clkM : in std_logic;

        dato_16b : in std_logic_vector(15 downto 0); -- Recibe la parte baja del dato. Para mostrarlo en la fpga es suficiente( códigos de ejemplo no llegan a números tan grandes)
        SSEG_AN0 : out std_logic;
        SSEG_AN1 : out std_logic;
        SSEG_AN2 : out std_logic;
        SSEG_AN3 : out std_logic;
        point : out std_logic;
        g : out std_logic;
        f : out std_logic;
        e : out std_logic;
        d : out std_logic;
        c : out std_logic;
        b : out std_logic;
        a : out std_logic
    );
end display;

architecture Behavioral of display is

    signal contadorClk : unsigned(19 downto 0) := (others => '0');
    signal selectorDisplay : std_logic_vector(1 downto 0);
    signal actual : std_logic_vector(3 downto 0);

    signal anodosDisplay : std_logic_vector(3 downto 0);
    signal segmentosDisplay : std_logic_vector(7 downto 0);

begin

    process(clkM)
    begin
        if rising_edge(clkM) then
            contadorClk <= contadorClk + 1;
        end if;
    end process;

    -- Usamos los bits 17 y 16 para cambiar de display a buena velocidad
    selectorDisplay <= std_logic_vector(contadorClk(17 downto 16));

    with selectorDisplay select
        actual <=
            dato_16b(3 downto 0)    when "00",
            dato_16b(7 downto 4)    when "01",
            dato_16b(11 downto 8)   when "10",
            dato_16b(15 downto 12)  when "11",
            "0000"                  when others;

    with selectorDisplay select
        anodosDisplay <=
            "1110" when "00",
            "1101" when "01",
            "1011" when "10",
            "0111" when "11",
            "1111" when others;

  
    with actual select
        segmentosDisplay <=
            "11000000" when "0000", -- 0
            "11111001" when "0001", -- 1
            "10100100" when "0010", -- 2
            "10110000" when "0011", -- 3
            "10011001" when "0100", -- 4
            "10010010" when "0101", -- 5
            "10000010" when "0110", -- 6
            "11111000" when "0111", -- 7
            "10000000" when "1000", -- 8
            "10010000" when "1001", -- 9
            "10001000" when "1010", -- A
            "10000011" when "1011", -- b
            "11000110" when "1100", -- C
            "10100001" when "1101", -- d
            "10000110" when "1110", -- E
            "10001110" when "1111", -- F
            "11111111" when others;

    SSEG_AN3 <= anodosDisplay(3);
    SSEG_AN2 <= anodosDisplay(2);
    SSEG_AN1 <= anodosDisplay(1);
    SSEG_AN0 <= anodosDisplay(0);

    point <= segmentosDisplay(7);
    g <= segmentosDisplay(6);
    f <= segmentosDisplay(5);
    e <= segmentosDisplay(4);
    d <= segmentosDisplay(3);
    c <= segmentosDisplay(2);
    b <= segmentosDisplay(1);
    a <= segmentosDisplay(0);

end Behavioral;


--testBench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity testDisplay is
end testDisplay;

architecture testeandoDisplay of testDisplay is

    signal clkM : std_logic := '0';
    signal dato_16b : std_logic_vector(15 downto 0);

    signal SSEG_AN0 : std_logic;
    signal SSEG_AN1 : std_logic;
    signal SSEG_AN2 : std_logic;
    signal SSEG_AN3 : std_logic;

    signal point : std_logic;
    signal g, f, e, d, c, b, a : std_logic;

begin

    DUT : entity work.display(Behavioral)
        port map(
            clkM => clkM,
            dato_16b => dato_16b,
            SSEG_AN0 => SSEG_AN0,
            SSEG_AN1 => SSEG_AN1,
            SSEG_AN2 => SSEG_AN2,
            SSEG_AN3 => SSEG_AN3,
            point => point,
            g => g, f => f, e => e, d => d, c => c, b => b, a => a
        );

    process
    begin
        while true loop
            clkM <= '0';
            wait for 5 ns;
            clkM <= '1';
            wait for 5 ns;
        end loop;
    end process;

    process
    begin
        -- Probamos a mostrar FFFF
        dato_16b <= X"FFFF";
        wait for 100 ms;

        -- Probamos a mostrar 3023
        dato_16b <= X"3023";
        wait for 100 ms;

        wait;
    end process;

end testeandoDisplay;