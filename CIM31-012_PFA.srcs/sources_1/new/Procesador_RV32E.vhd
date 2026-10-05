library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity Procesador_RV32E is
    Port ( 
        clk         : in std_logic;
        reset       : in std_logic;
        clk_fast      : in std_logic;                     -- Reloj de 100MHz para la RAM
        prog_mode     : in std_logic;                     -- '1' = Programando, '0' = Ejecutando
        prog_we       : in std_logic;                     -- Gatillo de escritura del Bootloader
        prog_addr     : in std_logic_vector(31 downto 0); -- Dirección del Bootloader
        prog_data     : in std_logic_vector(31 downto 0) ; -- Datos del Bootloader

        -- CABLES DE SALIDA TOP LEVEL 
        debug_alu   : out std_logic_vector(31 downto 0);
        debug_data  : out std_logic_vector(31 downto 0);
        MemWrite_n_4b : out std_logic_vector(3 downto 0);
        
        debug_reg_data : out std_logic_vector(31 downto 0);
        debug_reg_addr : out std_logic_vector(3 downto 0);
        debug_reg_we_n : out std_logic
    );
end Procesador_RV32E;

architecture Structural of Procesador_RV32E is 
    
  
    -- Señales para el Multiplexor de la Memoria
    signal ram_we_final   : std_logic;
    signal ram_addr_final : std_logic_vector(31 downto 0);
    signal ram_data_final : std_logic_vector(31 downto 0);
    
    
    signal s_PC          : std_logic_vector(31 downto 0);
    signal s_Instruction : std_logic_vector(31 downto 0);
    signal s_Opcode      : std_logic_vector(6 downto 0);
    signal s_Funct3      : std_logic_vector(2 downto 0);
    signal s_Funct7      : std_logic_vector(6 downto 0);
    signal s_Rd_5b       : std_logic_vector(4 downto 0);
    signal s_Rs1_5b      : std_logic_vector(4 downto 0);
    signal s_Rs2_5b      : std_logic_vector(4 downto 0);
    signal s_TypeSel     : std_logic_vector(2 downto 0);
    signal s_ICode       : std_logic_vector(3 downto 0);
    signal s_MuxPC             : std_logic_vector(1 downto 0);
    signal s_AluInputBMux      : std_logic;
    signal s_AluOperation      : std_logic_vector(3 downto 0);
    signal s_MemWrite          : std_logic;
    signal s_MemRead           : std_logic;
    signal s_RegWrite          : std_logic;
    signal s_RegWSelec         : std_logic_vector(3 downto 0);
    signal s_RegRead0Selec     : std_logic_vector(3 downto 0);
    signal s_RegRead1Selec      : std_logic_vector(3 downto 0);
    signal s_DatatoRegisterMux : std_logic_vector(1 downto 0);
    signal s_Q0, s_Q1       : std_logic_vector(31 downto 0); -- Salidas Banco Registros
    signal s_Imm            : std_logic_vector(31 downto 0); -- Salida ImmGen
    signal s_ALU_B          : std_logic_vector(31 downto 0); -- Entrada B de la ALU
    signal s_ALU_Result     : std_logic_vector(31 downto 0); -- Resultado de la ALU
    signal s_ZeroFlag       : std_logic;                     -- Flag de la ALU
    signal s_MemOut        : std_logic_vector(31 downto 0);
    signal s_WriteBackData : std_logic_vector(31 downto 0);
    signal s_PC_next       : std_logic_vector(31 downto 0);
    signal s_MemRead_n     : std_logic;
    signal s_MemWrite_n_4b : std_logic_vector(3 downto 0); -- Bus de 4 cables para los Byte Enables
    signal s_StoreData     : std_logic_vector(31 downto 0); -- Dato que va de la LSU a la RAM
    signal s_LoadData      : std_logic_vector(31 downto 0); -- Dato que va de la LSU al Banco de Registros
    
    

begin

    ram_we_final   <= prog_we   when prog_mode = '1' else '0';
    ram_addr_final <= prog_addr when prog_mode = '1' else s_PC; 
    ram_data_final <= prog_data when prog_mode = '1' else x"00000000";

    MemWrite_n_4b <= s_MemWrite_n_4b;
    
    debug_reg_data <= s_WriteBackData;
    debug_reg_addr <= s_RegWSelec;
    debug_reg_we_n <= s_RegWrite;

    s_PC_next <= std_logic_vector(unsigned(s_PC) + 1);
    
    Inst_CP: entity work.CP(Estructural) 
        port map (
            clk      => clk,
            resetCP  => reset,
            CPsel    => s_MuxPC,        -- Viene de la Unidad de Control
            offset   => s_Imm,          -- Salto inmediato del ImmGen
            rs1      => s_Q0,           --  Valor registro base (para JALR)
            ImmSel   => s_TypeSel,      -- Viene del PreDecode
            CPout    => s_PC            -- La dirección actual sale hacia la Memoria
        );

    Inst_MemInstr: entity work.MemInstr(Behavioral)
        port map (
            clk         => clk_fast,       -- Usa el reloj de 100MHz aquí
            we          => ram_we_final,
            din         => ram_data_final,
            direccion   => ram_addr_final,
            instruccion => s_Instruction   -- El cable interno que va a tu Unidad de Control
        );


    Inst_PreDecode: entity work.PreDecode(Behavioral)
        port map (
            Instruction => s_Instruction,
            Opcode      => s_Opcode,
            Funct3      => s_Funct3,
            Funct7      => s_Funct7,
            Rd          => s_Rd_5b,
            Rs1         => s_Rs1_5b,
            Rs2         => s_Rs2_5b,
            TypeSel     => s_TypeSel,
            ICode       => s_ICode
        );

    Inst_ControlUnit: entity work.ControlUnit(Base)
        port map (
            Rd          => s_Rd_5b(3 downto 0),
            Rs1         => s_Rs1_5b(3 downto 0),
            Rs2         => s_Rs2_5b(3 downto 0),
            TypeSel     => s_TypeSel,
            ICode       => s_ICode,
            ZeroFlag    => s_ZeroFlag,   
            CompareFlag   => s_ALU_Result(0),          
            MuxPC             => s_MuxPC,
            AluInputBMux      => s_AluInputBMux,
            AluOperation      => s_AluOperation,
            MemWrite          => s_MemWrite,
            MemRead           => s_MemRead,
            RegWrite          => s_RegWrite,
            RegWSelec         => s_RegWSelec,
            RegRead0Selec     => s_RegRead0Selec,
            RegRead1Selec      => s_RegRead1Selec,
            DatatoRegisterMux => s_DatatoRegisterMux
        );

    Inst_ImmGen: entity work.ImmGen(Behavioral)
        port map(
            instrIn => s_Instruction,
            ImmSel  => s_TypeSel, -- Usamos TypeSel para decidir el formato
            immOut  => s_Imm
        );

    
    Inst_BancoReg: entity work.Bank_R32(Structural)
        port map(
            Clk          => clk, 
            Reset        => reset,
            D            => s_WriteBackData, 
            Escritura    => s_RegWrite,
            SelectorEsc  => s_RegWSelec,
            SelectorLec0 => s_RegRead0Selec,
            SelectorLec1 => s_RegRead1Selec,
            Q0           => s_Q0,
            Q1           => s_Q1
        );

    -- MUX para la entrada B de la ALU
    s_ALU_B <= s_Q1 when s_AluInputBMux = '0' else s_Imm;

 
    Inst_ALU: entity work.ALU32(Structural)
        port map(
            A        => s_Q0,
            B        => s_ALU_B,
            Selector => s_AluOperation,
            Z        => s_ALU_Result,
            ZeroFlag => s_ZeroFlag
        );
        
        
        
    s_MemRead_n  <= s_MemRead;
   
    Inst_LSU: entity work.LoadStoreUnit(Behavioral)
        port map(
            Funct3         => s_Funct3,         -- Para saber si es LB, LBU, SB o SW
            WriteEnable_n    => s_MemWrite,       -- La orden de escritura original de la Unidad de Control
            addr     => s_ALU_Result,     -- Dirección calculada por la ALU
            StoreDataIn   => s_Q1,             -- Dato bruto que viene del registro rs2
            LoadDataOut   => s_LoadData,       -- Dato ya recortado/extendido para el registro
            LoadDatain     => s_MemOut,         -- Dato bruto de 32 bits que sale de la RAM
            MemWriteOut_n => s_MemWrite_n_4b,  -- Los 4 cables de Byte Enable hacia la RAM
            StoreDataOut  => s_StoreData       -- Dato alineado hacia la RAM
        );
        
        
    Inst_MemDatos: entity work.MemDatos(Behavioral)
        port map(
            clk       => clk, 
            enable_n  => '0',          -- Siempre habilitada
            read_n    => s_MemRead_n,  
            write_n   =>s_MemWrite_n_4b, --Recibe los 4 cables desde la LSU
            direccion => s_ALU_Result, -- La ALU calcula la dirección de memoria
            dataIn    => s_StoreData,  --Recibe el dato procesado desde la LSU
            dataOut   => s_MemOut
        );

    Inst_MUX4_Reg: entity work.MUX4_Reg(Behavioral)
        port map(
            D_ALU => s_ALU_Result,
            D_Mem => s_LoadData,
            D_Imm => s_Imm,
            D_CP  => s_PC_next, -- Usado para guardar la dir de retorno en JAL/JALR
            Sel   => s_DatatoRegisterMux,
            D_Out => s_WriteBackData
        );
    -- Conexión de los cables hacia fuera para conectarlos al display
    debug_alu   <= s_ALU_Result;
    debug_data  <= s_StoreData;
end Structural;