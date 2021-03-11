library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;
use ieee.NUMERIC_STD_UNSIGNED.all;

entity tb_program_counter is -- registrador que armazena endereços de instruções
end tb_program_counter;

architecture tb of tb_program_counter is

    -- declaracao de pc

    component program_counter is
        port(
             next_instruction_address : in std_logic_vector(4 downto 0);
             clk : in std_logic;
             current_instruction_address : out std_logic_vector(4 downto 0)
            );
    end component;

    -- clock

    constant clock_frequency : integer := 10e6; -- 10Mhz
    constant clock_period : time := 1000 ms /clock_frequency;

    signal clk : std_logic := '1';

    signal current_instruction_address, next_instruction_address : std_logic_vector(4 downto 0) := (others => '0');

    constant period: time := 400 ns;

    begin

    uut: program_counter port map(
                        clk  => clk ,
                        next_instruction_address => next_instruction_address,
                        current_instruction_address => current_instruction_address
                        );

    clk <= not clk after clock_period / 2;

    testbench: process

        begin

        next_instruction_address <= "00001";

        wait for period;

        next_instruction_address <= "00010";

        wait for period;

        next_instruction_address <= "00011";

        wait for period;

        next_instruction_address <= "00100";

        wait for period;

        next_instruction_address <= "00101";

    end process testbench;

end tb;
