library IEEE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity tb_data_memory is
end tb_data_memory;

architecture tb of tb_data_memory is

    -- declaracao de memoria de dados

    component data_memory is -- registrador de 32 palavras
        port(
        data_address : in std_logic_vector(4 downto 0);
        clk : in std_logic;
        we : in std_logic;
        write_data : in std_logic_vector(31 downto 0);
        data : out std_logic_vector(31 downto 0)
        );
    end component;

    -- declarao de constantes para clock

    constant clock_frequency : integer := 10e6; -- 10Mhz
    constant clock_period : time := 1000 ms /clock_frequency;

    -- inputs

    signal we : std_logic := '0';
    signal clk : std_logic := '0';
    signal data_address : std_logic_vector(4 downto 0) := (others => '0');
    signal write_data : std_logic_vector(31 downto 0) := (others => '0');

    -- outputs

    signal data : std_logic_vector(31 downto 0);

    begin

        -- instancia unidade sob teste

        uut: data_memory port map(
                                     data_address => data_address,
                                     clk => clk,
                                     we => we,
                                     write_data => write_data,
                                     data => data
                                   );

        -- define pulso de clock

        clk <= not clk after clock_period / 2;

        -- executa testbench

        test_bench: process

        constant period: time := 200 ns;

            begin

                wait for period;

                we <= '1';
                write_data <= "00000000000000000000000000000100";
                data_address <= "00001";

                wait for period;

                write_data <= "00000000000000000000000000000001";
                data_address <= "00010";

                wait for period;

                we <= '0';
                data_address <= "00001";

                wait for period;

                data_address <= "00010";

                wait for period;

        end process test_bench;
end tb;
