library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;
use ieee.NUMERIC_STD_UNSIGNED.all;

entity register_file is -- registrador de 32 palavras

    port(
         ra_1, ra_2, wa_3 : in std_logic_vector(4 downto 0);
         clk : in std_logic;
         we : in std_logic;
         wa_3_data : in std_logic_vector(31 downto 0);
         ra_1_data, ra_2_data : out std_logic_vector(31 downto 0)
        );

end register_file;

architecture register_arc of register_file is

    -- cria vetor de zeros para registrador 0

    constant zeros : std_logic_vector(0 to 31) := (others => '0');

    -- cria memoria ram

    type ram_memory is array (31 downto 0) of std_logic_vector(31 downto 0); -- 32 registradores de 32 bits cada

    signal mem: ram_memory := (others => (others => '0'));

    begin

        -- processo de escrita
        write: process(clk) -- o processo é sensivel apenas ao clock
        begin

        if rising_edge(clk) then  -- opera apenas nas subidas de clock
            if (we = '1') then  -- armazena dados apenas se write enable
                if ( to_integer(wa_3) /= 0 ) then -- se endereco for zero, nao escreve

                mem(to_integer(wa_3)) <= wa_3_data; -- armazena dados

                end if;
            end if;
        end if; -- o sintetizador induz memoria por meio da ausencia de clausulas catch all

        end process write;

        -- processo de leitura

        read: process(ra_1, ra_2, wa_3, clk,    -- sensivel a todos os sinais
                      we, wa_3_data)
        begin
            if( to_integer(ra_1) = 0 ) then
                ra_1_data <= zeros;

            else
                ra_1_data <= mem(to_integer(ra_1));
            end if;

            if( to_integer(ra_2) = 0 ) then
                ra_2_data <= zeros;

            else
                ra_2_data <= mem(to_integer(ra_2));
            end if;

        end process read;

end register_arc;
