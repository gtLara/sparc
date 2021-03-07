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
            reset : in std_logic;
            set : in std_logic;
            -- sinais de controle
            regwrite_source : in std_logic;
            data_we : in std_logic;
            register_we : in std_logic;
            alu_control : in std_logic_vector(3 downto 0)

            );
    end component;

    constant clock_frequency : integer := 10e6; -- 10Mhz
    constant clock_period : time := 1000 ms /clock_frequency;

    signal clk : std_logic := '1';
    signal data_we : std_logic := '0';
    signal register_we : std_logic := '1';
    signal regwrite_source : std_logic := '0';
    signal reset : std_logic := '0';
    signal set : std_logic := '0';
    signal alu_control : std_logic_vector(3 downto 0) := "0000";
    constant period: time := 200 ns;

    begin

    uut: sparc port map(
                        clk  => clk ,
                        reset => reset,
                        set => set,
                        regwrite_source => regwrite_source,
                        alu_control => alu_control,
                        data_we => data_we,
                        register_we => register_we
                        );

    clk <= not clk after clock_period / 2;

    testbench: process
        begin

        set <= '1'; -- carrega instrucoes de programa

        wait for period;

        wait for period;

        wait for period;

        wait for period;

        wait for period;

    end process testbench;

end tb;
