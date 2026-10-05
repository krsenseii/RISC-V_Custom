library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_rx is
    Port ( 
        clk        : in  std_logic;                    -- Reloj rápido de la placa (100 MHz)
        rx         : in  std_logic;                    -- El cable por donde llegan los bits del USB
        data_out   : out std_logic_vector(7 downto 0); -- El byte (8 bits) ya montado
        data_ready : out std_logic                     -- Se pone a '1' durante un ciclo cuando hay un byte nuevo
    );
end uart_rx;

architecture Behavioral of uart_rx is

    -- Definimos los estados de nuestra máquina "cazadora"
    type state_type is (IDLE, START_BIT, DATA_BITS, STOP_BIT);
    signal state : state_type := IDLE;

    -- Constantes para la sincronización a 9600 baudios con un reloj de 100MHz
    constant CLKS_PER_BIT : integer := 10416;
    
    -- Contadores y registros internos
    signal clk_count : integer range 0 to CLKS_PER_BIT - 1 := 0;
    signal bit_index : integer range 0 to 7 := 0;
    signal rx_data   : std_logic_vector(7 downto 0) := (others => '0');

begin

    process(clk)
    begin
        if rising_edge(clk) then
            
            -- Por defecto, la bandera de aviso está bajada
            data_ready <= '0';

            case state is
                
                -- 1. ESTADO DE REPOSO: Esperando a que la línea baje a '0' (Start Bit)
                when IDLE =>
                    clk_count <= 0;
                    bit_index <= 0;
                    if rx = '0' then
                        state <= START_BIT;
                    end if;

                -- 2. START BIT: Verificamos que es un '0' real leyendo en la mitad exacta del bit
                when START_BIT =>
                    if clk_count = (CLKS_PER_BIT / 2) then
                        if rx = '0' then
                            clk_count <= 0;  -- Reseteamos el reloj para empezar a medir los datos
                            state <= DATA_BITS;
                        else
                            state <= IDLE;   -- Era una falsa alarma (ruido)
                        end if;
                    else
                        clk_count <= clk_count + 1;
                    end if;

                -- 3. BITS DE DATO: Cazamos los 8 bits, uno a uno
                when DATA_BITS =>
                    if clk_count = CLKS_PER_BIT - 1 then
                        clk_count <= 0;
                        rx_data(bit_index) <= rx; -- Guardamos el bit cazado
                        
                        if bit_index < 7 then
                            bit_index <= bit_index + 1;
                        else
                            state <= STOP_BIT; -- Ya tenemos los 8 bits
                        end if;
                    else
                        clk_count <= clk_count + 1;
                    end if;

                -- 4. STOP BIT: Esperamos un poco para dejar que la línea vuelva a reposo ('1')
                when STOP_BIT =>
                    if clk_count = CLKS_PER_BIT - 1 then
                        data_out <= rx_data; -- Sacamos el byte al exterior
                        data_ready <= '1';   -- ¡AVISAMOS de que hay un dato nuevo!
                        state <= IDLE;       -- Volvemos a empezar
                    else
                        clk_count <= clk_count + 1;
                    end if;
                    
            end case;
        end if;
    end process;

end Behavioral;