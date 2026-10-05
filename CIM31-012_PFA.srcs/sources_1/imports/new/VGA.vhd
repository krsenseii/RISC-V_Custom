----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.06.2026 11:50:04
-- Design Name: 
-- Module Name: VGA - Behavioral
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

entity VGA is
    port(
        clkAuxRAM   : in std_logic; -- clock del divisor
        dataInRAM      : in  std_logic_vector(31 downto 0);
        dirRAM         : in  std_logic_vector(31 downto 0);
        MascWrite_n    : in  std_logic_vector(3 downto 0);
        
        dirAuxRAM      : in  std_logic_vector(9 downto 0);
        
        dataInReg   : in  std_logic_vector(31 downto 0);
        dirWriteReg : in  std_logic_vector(3 downto 0);
        weReg_n     : in  std_logic;
        
        clk : in  std_logic;  -- 100 MHz 
        btn_reset_n    : in  std_logic;  -- reset activo a '0'
        vgaRed         : out std_logic_vector(3 downto 0);
        vgaGreen       : out std_logic_vector(3 downto 0);
        vgaBlue        : out std_logic_vector(3 downto 0);
        Hsync          : out std_logic;
        Vsync          : out std_logic
    );
end VGA;


architecture Structural of VGA is

    signal s_dRAM          : std_logic_vector(31 downto 0);
    signal s_addrRAM       : std_logic_vector(31 downto 0);
    signal s_dAux          : std_logic_vector(31 downto 0);
    signal s_addrAux       : std_logic_vector(31 downto 0);

    signal s_sign_dRAM     : std_logic_vector(4 downto 0);
    signal s_dRAM_digits   : std_logic_vector(39 downto 0);
    signal s_addrRAM_digits: std_logic_vector(15 downto 0);

    signal s_sign_dAux     : std_logic_vector(4 downto 0);
    signal s_dAux_digits   : std_logic_vector(39 downto 0);
    signal s_addrAux_digits: std_logic_vector(15 downto 0);
    
    signal s_dReg          : std_logic_vector(31 downto 0);
    signal s_dirReadReg    : std_logic_vector(3 downto 0);
    signal s_sign_dReg     : std_logic_vector(4 downto 0);
    signal s_dReg_digits   : std_logic_vector(39 downto 0);
    

    signal s_weTextRAM_n   : std_logic;
    signal s_addrTextRAM_w : std_logic_vector(9 downto 0);
    signal s_addrTextRAM_r : std_logic_vector(9 downto 0);
    signal s_charText_w    : std_logic_vector(4 downto 0);
    signal s_charText_r    : std_logic_vector(4 downto 0);


    signal s_rom_col       : integer range 0 to 19;
    signal s_rom_fila      : integer range 0 to 19;
    signal s_rom_bit       : std_logic;

    signal s_dirAuxRAM32     : std_logic_vector(31 downto 0);
begin

    s_dirAuxRAM32 <= x"00000" & dirAuxRAM & "00";

    AuxRAM_use: entity work.AuxRAM(Behavioral)
        port map(
            clk          => clkAuxRAM,
            MascWrite_n   => MascWrite_n,
            direccion     => dirRAM,
            dataIn        => dataInRAM,
            dataOut       => s_dRAM,
            dataOutAux    => s_dAux,
            direccionAux  => s_dirAuxRAM32
        );

    BinToDec_use: entity work.BinToDec(Behavioral)
        port map(
            dRAM           => s_dRAM,
            addrRAM        => dirRAM(11 downto 2),
            dAux           => s_dAux,
            addrAux        => dirAuxRAM,
            dReg           => s_dReg,
            sign_dRAM      => s_sign_dRAM,
            dRAM_digits    => s_dRAM_digits,
            addrRAM_digits => s_addrRAM_digits,
            sign_dAux      => s_sign_dAux,
            dAux_digits    => s_dAux_digits,
            addrAux_digits => s_addrAux_digits,
            sign_dReg      => s_sign_dReg,
            dReg_digits    => s_dReg_digits
        );

    DecToDigit_use: entity work.DecToDigit(Behavioral)
        port map(
            clk            => clk,
            sign_sRAM      => s_sign_dRAM,
            dRAM_digits    => s_dRAM_digits,
            addrRAM_digits => s_addrRAM_digits,
            sign_dAux      => s_sign_dAux,
            dAux_digits    => s_dAux_digits,
            addrAux_digits => s_addrAux_digits,
            weTextRAM_n    => s_weTextRAM_n,
            addressTextRAM => s_addrTextRAM_w(9 downto 0),
            character_out  => s_charText_w,
            dirReadReg     => s_dirReadReg,
            sign_dReg      => s_sign_dReg,
            dReg_digits    => s_dReg_digits
        );

    TextRAM_use: entity work.TextRAM(Behavioral)
        port map(
            clk     => clk,
            we_n    => s_weTextRAM_n,
            addr_w  => s_addrTextRAM_w(9 downto 0),
            din     => s_charText_w,
            addr_r  => s_addrTextRAM_r(9 downto 0),
            dout    => s_charText_r
        );

    ROM_Letter_use: entity work.ROM_Letter(Behavioral)
        port map(
            entrada => s_charText_r,
            columna => s_rom_col,
            fila    => s_rom_fila,
            salida  => s_rom_bit
        );
        
    AuxReg_use: entity work.AuxReg(Behavioral)
        port map(
            clk => clkAuxRAM,
            RegWrite_n => weReg_n,
            dirWrite => dirWriteReg,
            dataIn => dataInReg,
            dirRead => s_dirReadReg,
            dataOut => s_dReg
        );

    vga_control_use: entity work.vga_control(Behavioral)
        port map(
            clk          => clk,
            btn_reset_n  => btn_reset_n,
            rom_bit      => s_rom_bit,
            text_addr_r  => s_addrTextRAM_r(9 downto 0),
            rom_col      => s_rom_col,
            rom_fila     => s_rom_fila,
            vgaRed       => vgaRed,
            vgaGreen     => vgaGreen,
            vgaBlue      => vgaBlue,
            Hsync        => Hsync,
            Vsync        => Vsync
        );

end Structural;
