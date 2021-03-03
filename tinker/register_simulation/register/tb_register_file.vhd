library IEEE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity tb_register_file is
end tb_register_file;

architecture tb of tb_register_file is


    -- declaracao de registrador

    component register_file is -- registrador de 32 palavras
        port(
         ra_1, ra_2, wa_3 : in std_logic_vector(4 downto 0);
         clk : in std_logic;
         we : in std_logic;
         wa_3_data : in std_logic_vector(31 downto 0);
         ra_1_data, ra_2_data : out std_logic_vector(31 downto 0)
        );
    end component;

    -- declarao de constantes para clock

    constant clock_frequency : integer := 10e6; -- 10Mhz
    constant clock_period : time := 1000 ms /clock_frequency;

    -- inputs

    signal we : std_logic := '1';
    signal clk : std_logic := '1';
    signal ra_1, ra_2, wa_3 : std_logic_vector(4 downto 0) := (others => '0'); 
    signal wa_3_data : std_logic_vector(31 downto 0) := (others => '0'); 
        
    -- outputs

    signal ra_1_data, ra_2_data : std_logic_vector(31 downto 0);

    begin

        -- instancia unidade sob teste

        uut: register_file port map(
                                 ra_1 => ra_1,
                                 ra_2 => ra_2,
                                 wa_3 =>  wa_3,
                                 clk => clk,
                                 we => we,
                                 wa_3_data => wa_3_data,
                                 ra_1_data => ra_1_data,
                                 ra_2_data => ra_2_data);

        -- define pulso de clock

        clk <= not clk after clock_period / 2;

        -- executa testbench

        test_bench: process

        constant period: time := 200 ns;

            begin

                wait for period;

                we <= '1';
                wa_3_data <= "11111000000000000000000000000000";
                wa_3 <= "00001";

                wait for period;
                
                wa_3_data <= "00000000000000000000000000011111";
                wa_3 <= "00010";

                wait for period;

                ra_1 <= "00001";
                ra_2 <= "00010";
                we <= '0';

                wait for period;

                wa_3_data <= "00000000000000000000000000000000";
                wa_3 <= "00010";

                wait for period;

                ra_1 <= "00001";
                ra_2 <= "00010";

                wait for period;

                ra_1 <= "00000";

                wait for period;        

        end process test_bench;
end tb;
