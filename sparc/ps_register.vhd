library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;
use ieee.NUMERIC_STD_UNSIGNED.all;

entity ps_register is -- registrador que armazena se ultima operacao da alu foi negativa

    port(
         psr_we : in std_logic;
         next_input : in std_logic;
         clk : in std_logic;
         last_input : out std_logic
        );

end ps_register;

-- essencialmente um flipflop. versao bem simplificado do psr real do sparc.

architecture ps_register_arc of ps_register is

    signal stored_signal: std_logic := '0';

    begin

        -- processo de escrita
        write: process(clk) -- o processo é sensivel apenas ao clock
        begin

        if rising_edge(clk) then  -- opera apenas nas subidas de clock
            if psr_we = '1' then

                stored_signal <= next_input; -- armazena dados

            end if;
        end if; -- o sintetizador induz memoria por meio da ausencia de clausulas catch all

        end process write;

        -- processo de leitura

        read: process(clk, next_input) -- sensivel a todos os sinais

        begin

            last_input <= stored_signal;

        end process read;

end ps_register_arc;
