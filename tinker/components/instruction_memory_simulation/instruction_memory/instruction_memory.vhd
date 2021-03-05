library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

library STD;
use STD.TEXTIO.ALL;

entity instruction_memory is

    port(
            set : in std_logic;
            address : in std_logic_vector(5 downto 0);
            instruction : out std_logic_vector(31 downto 0));

end instruction_memory;

architecture instruction_memory_arc of instruction_memory is

    type ram_32x32 is array (31 downto 0) of std_logic_vector(31 downto 0); -- 32 palavras  de 32 bits cada
    signal mem: ram_32x32;

    file program : text open read_mode is "program.txt";

    constant period: time := 200 ns;

    begin

    load: process(set)

        variable counter : integer := 0; 
        variable current_read_line : line;
        variable current_read_instruction : std_logic_vector(31 downto 0);

        begin

            while(not endfile(program)) loop
                readline(program, current_read_line);
                read(current_read_line, current_read_instruction);
                mem(counter) <= current_read_instruction;
                counter := counter + 1;
            end loop;

    end process load;

    read: process(address)
    begin

        instruction <= mem(to_integer(unsigned(address)));

    end process read;

end instruction_memory_arc;
