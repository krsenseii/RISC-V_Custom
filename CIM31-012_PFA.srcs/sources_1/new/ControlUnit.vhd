library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ControlUnit is
    Generic(word:integer :=32);
    Port (
       


        -- RV32E: 16 registros (4 bits)
        Rd          : in std_logic_vector(3 downto 0);
        Rs1         : in std_logic_vector(3 downto 0);
        Rs2         : in std_logic_vector(3 downto 0);

        -- Familias: 000:S, 001:I, 010:B, 011:J, 100:U, 101:R, 111:Others
        TypeSel     : in std_logic_vector(2 downto 0);

        -- Código local de 4 bits por familia
        ICode       : in std_logic_vector(3 downto 0);
        ZeroFlag: in std_logic;
        CompareFlag: in std_logic;
    
    MuxPC: out std_logic_vector (1 downto 0);
    AluInputBMux: out std_logic; -- 0 registro, 1 immgen
    AluOperation: out std_logic_vector(3 downto 0);
    MemWrite: out std_logic;
    MemRead: out std_logic;
  
    RegWrite: out std_logic;
    RegWSelec: out std_logic_vector(3 downto 0);
    RegRead0Selec: out std_logic_vector(3 downto 0);
    RegRead1Selec: out std_logic_vector(3 downto 0);
    DatatoRegisterMux: out std_logic_vector (1 downto 0)  -- 0 viene de ALU, 1 viene de Memoria  2 viene de ImmGen y 3 viene de PC

    );
end ControlUnit;

architecture Base of ControlUnit is

signal sfunct3 : std_logic_vector(2 downto 0);
signal sfunct7:  std_logic_vector(6 downto 0);
signal sRd,sRs1,sRs2: std_logic_vector (3 downto 0);



begin



sRd     <= Rd;

sRs1    <= Rs1;
sRs2    <= Rs2;

ControlUnitFSM: process (typeSel, ICode, Rd, Rs1, Rs2, ZeroFlag, CompareFlag)
    begin


        case typeSel is

            -- TIPO R
            when "101" => 
                case ICode is 
                    when "0000" => -- ADD
                        MuxPc             <= "00";
             
                        AluInputBMux      <= '0';
                        AluOperation      <= "0000";
                        MemWrite          <= '1';
                        MemRead           <= '1';

                        RegWrite          <= '0';
                        RegWSelec         <= Rd;
                        RegRead0Selec     <= Rs1;
                        RegRead1Selec      <= Rs2;
                        DatatoRegisterMux <= "00";
   

                    when "0001" => -- SUB
                        MuxPc             <= "00";
                   
                        AluInputBMux      <= '0';
                        AluOperation      <= "0001";
                        MemWrite          <= '1';
                        MemRead           <= '1';
              
                        RegWrite          <= '0';
                        RegWSelec         <= Rd;
                        RegRead0Selec     <= Rs1;
                        RegRead1Selec      <= Rs2;
                        DatatoRegisterMux <= "00";

                        
                    when "0010" => -- AND
                        MuxPc             <= "00";
              
                        AluInputBMux      <= '0';
                        AluOperation      <= "0100";
                        MemWrite          <= '1';
                        MemRead           <= '1';
                     
                        RegWrite          <= '0';
                        RegWSelec         <= Rd;
                        RegRead0Selec     <= Rs1;
                        RegRead1Selec      <= Rs2;
                        DatatoRegisterMux <= "00";
  

                    when "0011" => -- OR
                        MuxPc             <= "00";
        
                        AluInputBMux      <= '0';
                        AluOperation      <= "0101";
                        MemWrite          <= '1';
                        MemRead           <= '1';
                 
                        RegWrite          <= '0';
                        RegWSelec         <= Rd;
                        RegRead0Selec     <= Rs1;
                        RegRead1Selec      <= Rs2;
                        DatatoRegisterMux <= "00";


                    when "0100" => -- XOR
                        MuxPc             <= "00";
             
                        AluInputBMux      <= '0';
                        AluOperation      <= "0110";
                        MemWrite          <= '1';
                        MemRead           <= '1';
               
                        RegWrite          <= '0';
                        RegWSelec         <= Rd;
                        RegRead0Selec     <= Rs1;
                        RegRead1Selec      <= Rs2;
                        DatatoRegisterMux <= "00";
         

                    when "0101" => -- SLL
                        MuxPc             <= "00";
                  
                        AluInputBMux      <= '0';
                        AluOperation      <= "1000";
                        MemWrite          <= '1';
                        MemRead           <= '1';
                 
                        RegWrite          <= '0';
                        RegWSelec         <= Rd;
                        RegRead0Selec     <= Rs1;
                        RegRead1Selec      <= Rs2;
                        DatatoRegisterMux <= "00";
                
                    when "0110" => -- SRL
                        MuxPc             <= "00";
                
                        AluInputBMux      <= '0';
                        AluOperation      <= "1001";
                        MemWrite          <= '1';
                        MemRead           <= '1';
              
                        RegWrite          <= '0';
                        RegWSelec         <= Rd;
                        RegRead0Selec     <= Rs1;
                        RegRead1Selec      <= Rs2;
                        DatatoRegisterMux <= "00";
        
                    when "0111" => -- SRA
                        MuxPc             <= "00";
            
                        AluInputBMux      <= '0';
                        AluOperation      <= "1010";
                        MemWrite          <= '1';
                        MemRead           <= '1';
     
                        RegWrite          <= '0';
                        RegWSelec         <= Rd;
                        RegRead0Selec     <= Rs1;
                        RegRead1Selec      <= Rs2;
                        DatatoRegisterMux <= "00";
        

                    when "1000" => -- SLT
                        MuxPc             <= "00";
                    
                        AluInputBMux      <= '0';
                        AluOperation      <= "1100";
                        MemWrite          <= '1';
                        MemRead           <= '1';
            
                        RegWrite          <= '0';
                        RegWSelec         <= Rd;
                        RegRead0Selec     <= Rs1;
                        RegRead1Selec      <= Rs2;
                        DatatoRegisterMux <= "00";
         

                    when "1001" => -- SLTU
                        MuxPc             <= "00";
                  
                        AluInputBMux      <= '0';
                        AluOperation      <= "1101";
                        MemWrite          <= '1';
                        MemRead           <= '1';
     
                        RegWrite          <= '0';
                        RegWSelec         <= Rd;
                        RegRead0Selec     <= Rs1;
                        RegRead1Selec      <= Rs2;
                        DatatoRegisterMux <= "00";


                    when others => 
                            MuxPc<="00";--nop
                  
                            AluInputBMux<= '0';
                            AluOperation <= "0000";
                            MemWrite<= '1';
                            MemRead<= '1';
          
                            RegWrite <= '1';
                            RegWSelec<= rd;
                            RegRead0Selec<= rs1;
                            RegRead1Selec<= rs2;
                            DatatoRegisterMux<="00";
                
                end case;

            -- TIPO I
            when "001" =>
                case ICode is
                    when "0000" => -- ADDI
                        MuxPc             <= "00";
                  
                        AluInputBMux      <= '1';
                        AluOperation      <= "0000";
                        MemWrite          <= '1';
                        MemRead           <= '1';
         
                        RegWrite          <= '0';
                        RegWSelec         <= Rd;
                        RegRead0Selec     <= Rs1;
                        RegRead1Selec      <= Rs2;
                        DatatoRegisterMux <= "00";
     
                    when "0001" => -- ANDI
                        MuxPc             <= "00";
                   
                        AluInputBMux      <= '1';
                        AluOperation      <= "0100";
                        MemWrite          <= '1';
                        MemRead           <= '1';
           
                        RegWrite          <= '0';
                        RegWSelec         <= Rd;
                        RegRead0Selec     <= Rs1;
                        RegRead1Selec      <= Rs2;
                        DatatoRegisterMux <= "00";
                 
                    when "0010" => -- ORI
                        MuxPc             <= "00";
             
                        AluInputBMux      <= '1';
                        AluOperation      <= "0101";
                        MemWrite          <= '1';
                        MemRead           <= '1';
                  
                        RegWrite          <= '0';
                        RegWSelec         <= Rd;
                        RegRead0Selec     <= Rs1;
                        RegRead1Selec      <= Rs2;
                        DatatoRegisterMux <= "00";
                    when "0011" => -- XORI
                         MuxPc             <= "00";
                   
                        AluInputBMux      <= '1';
                        AluOperation      <= "0110";
                        MemWrite          <= '1';
                        MemRead           <= '1';
                 
                        RegWrite          <= '0';
                        RegWSelec         <= Rd;
                        RegRead0Selec     <= Rs1;
                        RegRead1Selec      <= Rs2;
                        DatatoRegisterMux <= "00";
                    when "0100" => -- SLLI
                        MuxPc             <= "00";
                    
                        AluInputBMux      <= '1';
                        AluOperation      <= "1000";
                        MemWrite          <= '1';
                        MemRead           <= '1';
       
                        RegWrite          <= '0';
                        RegWSelec         <= Rd;
                        RegRead0Selec     <= Rs1;
                        RegRead1Selec      <= Rs2;
                        DatatoRegisterMux <= "00";
                    when "0101" => -- SRLI
                        MuxPc             <= "00";
             
                        AluInputBMux      <= '1';
                        AluOperation      <= "1001";
                        MemWrite          <= '1';
                        MemRead           <= '1';
         
                        RegWrite          <= '0';
                        RegWSelec         <= Rd;
                        RegRead0Selec     <= Rs1;
                        RegRead1Selec      <= Rs2;
                        DatatoRegisterMux <= "00";
                    when "0110" => -- SRAI
                          MuxPc             <= "00";
           
                        AluInputBMux      <= '1';
                        AluOperation      <= "1010";
                        MemWrite          <= '1';
                        MemRead           <= '1';
          
                        RegWrite          <= '0';
                        RegWSelec         <= Rd;
                        RegRead0Selec     <= Rs1;
                        RegRead1Selec      <= Rs2;
                        DatatoRegisterMux <= "00";
                    when "0111" => -- SLTI
                        MuxPc             <= "00";
                        AluInputBMux      <= '1';
                        AluOperation      <= "1110";
                        MemWrite          <= '1';
                        MemRead           <= '1';
               
                        RegWrite          <= '0';
                        RegWSelec         <= Rd;
                        RegRead0Selec     <= Rs1;
                        RegRead1Selec      <= Rs2;
                        DatatoRegisterMux <= "00";
                    when "1000" => -- SLTIU
                        MuxPc             <= "00";
                 
                        AluInputBMux      <= '1';
                        AluOperation      <= "1111";
                        MemWrite          <= '1';
                        MemRead           <= '1';
                 
                        RegWrite          <= '0';
                        RegWSelec         <= Rd;
                        RegRead0Selec     <= Rs1;
                        RegRead1Selec      <= Rs2;
                        DatatoRegisterMux <= "00";
                    
                    -- LOADS
                    when "1001" => -- LB
                        MuxPc             <= "00";
         
                        AluInputBMux      <= '0';
                        AluOperation      <= "0000";
                        MemWrite          <= '1';
                        MemRead           <= '0';
             
                        RegWrite          <= '0';
                        RegWSelec         <= Rd;
                        RegRead0Selec     <= Rs1;
                        RegRead1Selec      <= Rs2;
                        DatatoRegisterMux <= "01";
                    when "1010" => -- LH
                        MuxPc             <= "00";
                     
                        AluInputBMux      <= '1';
                        AluOperation      <= "0000";
                        MemWrite          <= '1';
                        MemRead           <= '0';
              
                        RegWrite          <= '0';
                        RegWSelec         <= Rd;
                        RegRead0Selec     <= Rs1;
                        RegRead1Selec      <= Rs2;
                        DatatoRegisterMux <= "01";
                    when "1011" => -- LW
                        MuxPc             <= "00";
                    
                        AluInputBMux      <= '1';
                        AluOperation      <= "0000";
                        MemWrite          <= '1';
                        MemRead           <= '0';
          
                        RegWrite          <= '0';
                        RegWSelec         <= Rd;
                        RegRead0Selec     <= Rs1;
                        RegRead1Selec      <= Rs2;
                        DatatoRegisterMux <= "01";
                    when "1100" => -- LBU
                       MuxPc             <= "00";
                    
                        AluInputBMux      <= '1';
                        AluOperation      <= "0000";
                        MemWrite          <= '1';
                        MemRead           <= '0';
             
                        RegWrite          <= '0';
                        RegWSelec         <= Rd;
                        RegRead0Selec     <= Rs1;
                        RegRead1Selec      <= Rs2;
                        DatatoRegisterMux <= "01";
                    when "1101" => -- LHU
                        MuxPc             <= "00";
                  
                        AluInputBMux      <= '1';
                        AluOperation      <= "0000";
                        MemWrite          <= '1';
                        MemRead           <= '0';
                 
                        RegWrite          <= '0';
                        RegWSelec         <= Rd;
                        RegRead0Selec     <= Rs1;
                        RegRead1Selec      <= Rs2;
                        DatatoRegisterMux <= "01";
                        
                    -- JALR
                    when "1110" => -- JALR
                        MuxPc             <= "10";
                    
                        AluInputBMux      <= '0';
                        AluOperation      <= "0000";
                        MemWrite          <= '1';
                        MemRead           <= '1';
                
                        RegWrite          <= '0';
                        RegWSelec         <= Rd;
                        RegRead0Selec     <= Rs1;
                        RegRead1Selec      <= Rs2;
                        DatatoRegisterMux <= "11";
                        
                    when others =>
                            MuxPc<="00";--nop
                    
                            AluInputBMux<= '0';
                            AluOperation <= "0000";
                            MemWrite<= '1';
                            MemRead<= '1';
               
                            RegWrite <= '1';
                            RegWSelec<= rd;
                            RegRead0Selec<= rs1;
                            RegRead1Selec<= rs2;
                            DatatoRegisterMux<="00";
                end case;

            -- TIPO S
            when "000" =>
                case ICode is
                    when "0000" => -- SB
                            MuxPc<="00";
               
                            AluInputBMux<= '1';
                            AluOperation <= "0000";
                            MemWrite<= '0';
                            MemRead<= '1';
             
                            RegWrite <= '1';
                            RegWSelec<= rd;
                            RegRead0Selec<= rs1;
                            RegRead1Selec<= rs2;
                            DatatoRegisterMux<="00";
                    when "0001" => -- SH
                            MuxPc<="00";
                           
                            AluInputBMux<= '1';
                            AluOperation <= "0000";
                            MemWrite<= '0';
                            MemRead<= '1';
          
                            RegWrite <= '1';
                            RegWSelec<= rd;
                            RegRead0Selec<= rs1;
                            RegRead1Selec<= rs2;
                            DatatoRegisterMux<="00";
                    when "0010" => -- SW
                            MuxPc<="00";
                            
                            AluInputBMux<= '1';
                            AluOperation <= "0000";
                            MemWrite<= '0';
                            MemRead<= '1';

                            RegWrite <= '1';
                            RegWSelec<= rd;
                            RegRead0Selec<= rs1;
                            RegRead1Selec<= rs2;
                            DatatoRegisterMux<="00";
                    when others =>
                            MuxPc<="00";--nop
                 
                            AluInputBMux<= '0';
                            AluOperation <= "0000";
                            MemWrite<= '1';
                            MemRead<= '1';

                            RegWrite <= '1';
                            RegWSelec<= rd;
                            RegRead0Selec<= rs1;
                            RegRead1Selec<= rs2;
                            DatatoRegisterMux<="00";
                end case;

            -- TIPO B
            when "010" =>
                case ICode is
                    when "0000" => -- BEQ
                            if (ZeroFlag = '1') then
                                    MuxPc <= "01"; -- Salta al destino (PC + Offset)
                                else
                                    MuxPc <= "00"; -- Sigue normal (PC + 1)
                                end if;
                
                            AluInputBMux<= '0';
                            AluOperation <= "0001";
                            MemWrite<= '1';
                            MemRead<= '1';

                            RegWrite <= '1';
                            RegWSelec<= rd;
                            RegRead0Selec<= rs1;
                            RegRead1Selec<= rs2;
                            DatatoRegisterMux<="00";
                    when "0001" => -- BNE
                            if ZeroFlag = '1' then
                            MuxPC <= "00";
                            else MuxPc <= "01";
                            end if;
                
                            AluInputBMux<= '0';
                            AluOperation <= "0001";
                            MemWrite<= '1';
                            MemRead<= '1';

                            RegWrite <= '1';
                            RegWSelec<= rd;
                            RegRead0Selec<= rs1;
                            RegRead1Selec<= rs2;
                            DatatoRegisterMux<="00";
                    when "0010" => -- BLT
                            if CompareFlag = '0' then
                            MuxPC <= "00";
                            else MuxPc <= "01";
                            end if;
                            AluInputBMux<= '0';
                            AluOperation <= "1110";
                            MemWrite<= '1';
                            MemRead<= '1';

                            RegWrite <= '1';
                            RegWSelec<= rd;
                            RegRead0Selec<= rs1;
                            RegRead1Selec<= rs2;
                            DatatoRegisterMux<="00";
                    when "0011" => -- BGE
                            if CompareFlag = '1' then
                            MuxPC <= "00";
                            else MuxPc <= "01";
                            end if;
                            AluInputBMux<= '0';
                            AluOperation <= "1110";
                            MemWrite<= '1';
                            MemRead<= '1';

                            RegWrite <= '1';
                            RegWSelec<= rd;
                            RegRead0Selec<= rs1;
                            RegRead1Selec<= rs2;
                            DatatoRegisterMux<="00";
                    when "0100" => -- BLTU
                            if CompareFlag = '1' then
                            MuxPC <= "00";
                            else MuxPc <= "01";
                            end if;
                            AluInputBMux<= '0';
                            AluOperation <= "1111";
                            MemWrite<= '1';
                            MemRead<= '1';

                            RegWrite <= '1';
                            RegWSelec<= rd;
                            RegRead0Selec<= rs1;
                            RegRead1Selec<= rs2;
                            DatatoRegisterMux<="00";
                    when "0101" => -- BGEU
                            if CompareFlag = '0' then
                            MuxPC <= "00";
                            else MuxPc <= "01";
                            end if;
                            AluInputBMux<= '0';
                            AluOperation <= "1111";
                            MemWrite<= '1';
                            MemRead<= '1';

                            RegWrite <= '1';
                            RegWSelec<= rd;
                            RegRead0Selec<= rs1;
                            RegRead1Selec<= rs2;
                            DatatoRegisterMux<="00";
                    when others =>
                            MuxPc<="00";--nop
                    
                            AluInputBMux<= '0';
                            AluOperation <= "0000";
                            MemWrite<= '1';
                            MemRead<= '1';

                            RegWrite <= '1';
                            RegWSelec<= rd;
                            RegRead0Selec<= rs1;
                            RegRead1Selec<= rs2;
                            DatatoRegisterMux<="00";
                end case;

            -- TIPO J
            when "011" =>
                case ICode is
                    when "0000" => -- JAL
                            MuxPc             <= "01";
                            AluInputBMux      <= '0';
                            AluOperation      <= "0000";
                            MemWrite          <= '1';
                            MemRead           <= '1';
                            
                            RegWrite          <= '0'; 
                            RegWSelec         <= Rd;
                            RegRead0Selec     <= Rs1;
                            RegRead1Selec     <= Rs2;
                            DatatoRegisterMux <= "11"; 
                    when others =>
                            MuxPc<="00";--nop
                    
                            AluInputBMux<= '0';
                            AluOperation <= "0000";
                            MemWrite<= '1';
                            MemRead<= '1';

                            RegWrite <= '1';
                            RegWSelec<= rd;
                            RegRead0Selec<= rs1;
                            RegRead1Selec<= rs2;
                            DatatoRegisterMux<="00";
                end case;

            -- TIPO U
            when "100" =>
                case ICode is
                    when "0000" => -- LUI
                            MuxPc<="00";
                    
                            AluInputBMux<= '0';
                            AluOperation <= "0000";
                            MemWrite<= '1';
                            MemRead<= '1';

                            RegWrite <= '0';
                            RegWSelec<= rd;
                            RegRead0Selec<= rs1;
                            RegRead1Selec<= rs2;
                            DatatoRegisterMux<="10";
                    when "0001" => -- AUIPC
                            MuxPc<="00";
                    
                            AluInputBMux<= '0';
                            AluOperation <= "0000";
                            MemWrite<= '1';
                            MemRead<= '1';

                            RegWrite <= '0';
                            RegWSelec<= rd;
                            RegRead0Selec<= rs1;
                            RegRead1Selec<= rs2;
                            DatatoRegisterMux<="11";
                    when others =>
                            MuxPc<="00";--nop
                    
                            AluInputBMux<= '0';
                            AluOperation <= "0000";
                            MemWrite<= '1';
                            MemRead<= '1';

                            RegWrite <= '1';
                            RegWSelec<= rd;
                            RegRead0Selec<= rs1;
                            RegRead1Selec<= rs2;
                            DatatoRegisterMux<="00";
                end case;

            -- OTHERS
            when "111" =>
                case ICode is
                    when "0000" => -- WFI
                            MuxPc<="11";
                    
                            AluInputBMux<= '0';
                            AluOperation <= "0000";
                            MemWrite<= '1';
                            MemRead<= '1';

                            RegWrite <= '1';
                            RegWSelec<= rd;
                            RegRead0Selec<= rs1;
                            RegRead1Selec<= rs2;
                            DatatoRegisterMux<="00";
                    when others => -- INVALID / DEFAULT
                            MuxPc<="00";--nop
                    
                            AluInputBMux<= '0';
                            AluOperation <= "0000";
                            MemWrite<= '1';
                            MemRead<= '1';

                            RegWrite <= '1';
                            RegWSelec<= rd;
                            RegRead0Selec<= rs1;
                            RegRead1Selec<= rs2;
                            DatatoRegisterMux<="00";
                end case;

            -- != TypeSel
            when others => 
                            MuxPc<="00";--nop
                    
                            AluInputBMux<= '0';
                            AluOperation <= "0000";
                            MemWrite<= '1';
                            MemRead<= '1';

                            RegWrite <= '1';
                            RegWSelec<= rd;
                            RegRead0Selec<= rs1;
                            RegRead1Selec<= rs2;
                            DatatoRegisterMux<="00";

        end case;
    end process;

end Base;
