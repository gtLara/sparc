-- Esse testbench é simples; simplesmente instancia o processador e dá
-- início a sua execução sob um sinal de clock. A execução do programa em
-- memória é auto contida.

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
            instruction_address : out std_logic_vector(4 downto 0)
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

    signal instruction_address : std_logic_vector(4 downto 0);

    begin

    uut: sparc port map(
                        clk  => clk ,
                        reset => reset,
                        set => set,
                        instruction_address => instruction_address
                        );

    clk <= not clk after clock_period / 2;

    testbench: process
        begin

        set <= '1'; -- carrega instrucoes de programa

        wait until instruction_address = "01001";

        -- Mecanismo de parada independente de modelsim. não utilizado

        assert false report "O programa encerrou";


    end process testbench;

end tb;
