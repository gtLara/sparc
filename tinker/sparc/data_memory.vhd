library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;
use ieee.NUMERIC_STD_UNSIGNED.all;

entity data_memory is -- memoria de dados de 32 palavras

    port(
         data_address: in std_logic_vector(4 downto 0); -- data address
         clk : in std_logic;
         we : in std_logic;
         write_data : in std_logic_vector(31 downto 0);
         data : out std_logic_vector(31 downto 0)
        );

end data_memory;

architecture data_arc of data_memory is

    -- cria memoria ram 32x32 ; armazena 32 palavras de 32 bits

    type ram_4x32 is array (0 to 3) of std_logic_vector(31 downto 0);

    signal mem: ram_4x32 := ("00000000000000000000000000000100",
                             "00000000000000000000000000000001",
                             "00000000000000000000000000000000",
                             "00000000000000000000000000000000");

    begin

        -- processo de escrita

        write: process(clk) -- o processo eh sensivel apenas ao clock
        begin

        if rising_edge(clk) then  -- opera apenas nas subidas de clock
            if (we = '1') then  -- armazena dados apenas se write enable
                mem(to_integer(data_address)) <= write_data ; -- armazena dados
            end if;
        end if; -- o sintetizador induz memoria por meio da ausencia de clausulas catch all

        end process write;

        -- processo de leitura

        read: process(data_address, clk, write_data)   -- sensivel a todos os sinais

        begin

            if to_integer(data_address) < 5 then
                data <= mem(to_integer(data_address));
            end if;

        end process read;

end data_arc;
