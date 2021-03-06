library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity tb_sparc is
end tb_sparc;

architecture tb of tb_sparc is

    component sparc is
        port(
            clk : in std_logic;
            reset : in std_logic
            );
    end component;

    constant clock_frequency : integer := 10e6; -- 10Mhz
    constant clock_period : time := 1000 ms /clock_frequency;

    signal clk : std_logic := '1';
    signal reset : std_logic := '0';
    constant period: time := 200 ns;

    begin

    uut: sparc port map(
                        clk  => clk ,
                        reset => reset
                        );

    clk <= not clk after clock_period / 2;

    testbench: process
        begin

        wait for period;

        wait for period;

    end process testbench;

end tb;
