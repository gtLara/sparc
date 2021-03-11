library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;
use ieee.NUMERIC_STD_UNSIGNED.all;

entity program_counter is -- registrador que armazena endereços de instruções

    port(
         next_instruction_address : in std_logic_vector(4 downto 0);
         clk : in std_logic;
         current_instruction_address : out std_logic_vector(4 downto 0)
        );

end program_counter;

architecture program_counter_arc of program_counter is

    -- cria memoria ram

    signal instruction_address: std_logic_vector(4 downto 0) := (others => '0');

    begin

        -- processo de escrita
        write: process(clk) -- o processo eh sensivel apenas ao clock
        begin

        if rising_edge(clk) then  -- opera apenas nas subidas de clock

            instruction_address <= next_instruction_address; -- armazena dados

        end if; -- o sintetizador induz memoria por meio da ausencia de clausulas catch all

        end process write;

        -- processo de leitura

        read: process(clk, next_instruction_address) -- sensivel a todos os sinais
                      
        begin
            
            current_instruction_address <= instruction_address;

        end process read;

end program_counter_arc;
