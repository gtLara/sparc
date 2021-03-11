library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity control is
    port(
         opcode : in std_logic_vector(5 downto 0);
         format : in std_logic_vector(1 downto 0);
-- sinal que determina se ocorre escrita em memoria de dados
         data_we : out std_logic;
-- sinal que determina se pode ocorrer um branch (depende adicionalmente da saida negativa da alu. vide documentacao)
         branch : out std_logic;
-- subal que determina se ocorre escrita nos registradores
         register_we : out std_logic;
-- subal que determina a fonte do dado a ser escrito nos registradores (entre saida da memoria de dados ou da alu)
         regwrite_source : out std_logic;
-- subal que determina se ocorre escrita no psr
         psr_we : out std_logic;
-- subal que determina a operacao da alu
         alu_control : out std_logic_vector(3 downto 0));
end entity;

architecture control_arc of control is

begin

    control: process(opcode, format)
        begin
            case (format) is

                when "11" => -- ld
                    alu_control <= "0000";
                    branch <= '0';
                    regwrite_source <= '1';
                    psr_we <= '0';

                when "10" =>-- arithmetic instructions
                    case(opcode) is

                        when "000000" => -- add
                            alu_control <= "0000";
                            branch <= '0';
                            regwrite_source <= '0';
                            psr_we <= '0';

                        when "010001" => -- and
                            alu_control <= "0010";
                            branch <= '0';
                            regwrite_source <= '0';
                            psr_we <= '0';

                        when "000111" => -- xor
                            branch <= '0';
                            alu_control <= "0100";
                            regwrite_source <= '0';
                            psr_we <= '0';

                        when "100110" => -- srl
                            alu_control <= "0111";
                            branch <= '0';
                            regwrite_source <= '0';
                            psr_we <= '0';

                        when "010100" => -- subcc
                            alu_control <= "0001";
                            branch <= '0';
                            regwrite_source <= '0';
                            psr_we <= '1';

                        when others => null; -- deadcase

                    end case;

                when "00" => -- bl
                    alu_control <= "0000";
                    psr_we <= '0';
                    branch <= '1';

                when others => null; -- deadcase

                end case;

            end process control;

            -- esses sinais sao iguais para todas instrucoes implementadas

            data_we <= '0';
            register_we <= '1';

end control_arc;
