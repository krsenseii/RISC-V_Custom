----------------------------------------------------------------------------------
-- TOP LEVEL FÍSICO PARA LA PLACA BASYS 3
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top_FPGA is
    Port ( 
        -- Entradas físicas de la placa
        clk_100MHz : in  std_logic;
        sw15  : in  std_logic;
        RsRx : in  std_logic;
          
        leds : out std_logic_vector (15 downto 0);
        -- vga port
        btn_reset_n    : in std_logic;
        vgaRed         : out std_logic_vector(3 downto 0);
        vgaGreen       : out std_logic_vector(3 downto 0);
        vgaBlue        : out std_logic_vector(3 downto 0);
        Hsync          : out std_logic;
        Vsync          : out std_logic;
        sw_addrRAM     : in std_logic_vector(9 downto 0)
    );
end Top_FPGA;

architecture Structural of Top_FPGA is

  
    signal clk_cpu : std_logic;

    -- Cables que salen del procesador  para ver dir/datos
    signal s_debug_alu   : std_logic_vector(31 downto 0);
    signal s_debug_data  : std_logic_vector(31 downto 0);
    signal s_MascRAM_n   : std_logic_vector(3 downto 0);
        
    signal s_debug_reg_data : std_logic_vector(31 downto 0);
    signal s_debug_reg_addr : std_logic_vector(3 downto 0);
    signal s_debug_reg_we_n : std_logic;
    
        signal uart_dato  : std_logic_vector(7 downto 0);
        signal uart_listo : std_logic;
        
        -- Señales que salen del Bootloader y entran a la CPU
        signal boot_we    : std_logic;
        signal boot_addr  : std_logic_vector(31 downto 0);
        signal boot_data  : std_logic_vector(31 downto 0);
       signal nsw15 : std_logic;
 
begin
    nsw15 <= not sw15;
   -- DEBUG DE EMERGENCIA:
    leds(7 downto 0)  <= uart_dato;  -- Los 8 LEDs de la derecha mostrarán el byte que llega por USB
    leds(14 downto 8) <= (others => '0');
    leds(15)          <= sw15;       -- El LED de la izquierda del todo te confirma si el switch va
    Inst_Div1Hz: entity work.div1hz(Behavioral)
        port map(
            clockInput => clk_100MHz,
            clk1Hz     => clk_cpu
        );


    Inst_CPU: entity work.Procesador_RV32E
        port map(
            clk         => clk_cpu,      -- Usa el reloj lento
            reset       => sw15,
            clk_fast    => clk_100MHz,
            debug_alu   => s_debug_alu,  -- Sale la dirección completa
            debug_data  => s_debug_data, -- Sale el dato completo
            MemWrite_n_4b => s_MascRAM_n,
            prog_mode => nsw15,
            prog_we => boot_we,
            prog_addr => boot_addr,
            prog_data => boot_data,
            debug_reg_data => s_debug_reg_data,
            debug_reg_addr => s_debug_reg_addr, 
            debug_reg_we_n   => s_debug_reg_we_n
        );

        
     VGA_use: entity work.VGA(Structural)
        port map(
            clkAuxRAM => clk_cpu,
            dataInRAM => s_debug_data,
            dirRAM => s_debug_alu,
            MascWrite_n => s_MascRAM_n,
            
            dirAuxRAM => sw_addrRAM,
            
            
            dataInReg   => s_debug_reg_data,
            dirWriteReg => s_debug_reg_addr,
            weReg_n     => s_debug_reg_we_n,
            
            
            clk => clk_100MHz,
            btn_reset_n => btn_reset_n,
            vgaRed => vgaRed,
            vgaGreen => vgaGreen,
            vgaBlue => vgaBlue,
            Hsync => Hsync,
            Vsync => Vsync
        );
        
        
        UART_use: entity work.uart_rx(Behavioral)
            port map(
                clk => clk_100MHz,
                rx => RsRx,
                data_out => uart_dato,
                data_ready => uart_listo
            );
  
        BOOTLOADER_use: entity work.bootloader(Behavioral)
            port map(
                clk => clk_100MHz,
                enable => nsw15,
                uart_data => uart_dato,
                uart_ready => uart_listo,
                
                ram_we => boot_we,
                ram_addr => boot_addr,
                ram_data => boot_data
            );
        

end architecture Structural;