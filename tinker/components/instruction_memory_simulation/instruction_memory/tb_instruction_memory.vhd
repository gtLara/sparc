library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

library STD;
use STD.TEXTIO.ALL;


entity tb_instruction_memory is
end tb_instruction_memory;

architecture tb of tb_instruction_memory is

    component instruction_memory is

            port(
                set : in std_logic;
                address : in std_logic_vector(5 downto 0);
                instruction : out std_logic_vector(31 downto 0));

    end component;

    -- input

    signal set : std_logic := '0';
    signal address : std_logic_vector(5 downto 0) := (others => 'U');

    -- output

    signal instruction : std_logic_vector(31 downto 0);

    begin

    -- instancia unidade

    uut: instruction_memory port map(
                                set => set,
                                address => address,
                                instruction => instruction
                                );

    test_bench: process

        -- carrega programa e memoria

        file program : text open read_mode is "program.txt";
        variable current_read_line : line;
        variable current_read_instruction : std_logic_vector(31 downto 0);

        variable current_write_line : line; -- temp

        constant period: time := 200 ns;

        begin
            
            while(not endfile(program)) loop

                readline(program, current_read_line);
                read(current_read_line, current_read_instruction);
                write(current_write_line, current_read_instruction);
                writeline(output, current_write_line);

            end loop;

            wait for period;

            set <= '1';

            wait for period;

            set <= '0';

            wait for period;

            address <= "000000";

            wait for period;

            address <= "000001";

            wait for period;

            address <= "000010";

            wait for period;

        end process test_bench;

end tb;
