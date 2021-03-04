library IEEE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity tb_alu is
end tb_alu;

architecture tb of tb_alu is

    -- declaracao de alu

    component alu is
        port(
            src_a : in std_logic_vector(31 downto 0);
            src_b: in std_logic_vector(31 downto 0);
            shift_amount: in std_logic_vector(5 downto 0);
            alu_control : in std_logic_vector(3 downto 0);
            alu_result : out std_logic_vector(31 downto 0);
            zero : out std_logic);
    end component;

        -- inputs

        signal src_a : std_logic_vector(31 downto 0) := (others => '0');
        signal src_b : std_logic_vector(31 downto 0) := (others => '0');
        signal alu_control : std_logic_vector(3 downto 0) := (others => '0');
        signal shift_amount: std_logic_vector(5 downto 0) := (others => '0');

        -- outputs

        signal alu_result : std_logic_vector(31 downto 0);
        signal zero : std_logic;

        begin

        -- instancia unidade sob teste

        uut: alu port map(
                            src_a => src_a,
                            src_b => src_b,
                            alu_control => alu_control,
                            shift_amount => shift_amount,
                            alu_result => alu_result,
                            zero => zero);

        -- executa testbench, variando entradas para verificar saidas

        test_bench: process

            constant period: time := 100 ns;
            begin
                wait for period;

                src_a <= "11111111100000000000000000000000";
                src_b <= "11111111111111111111111111111111";

                wait for period;

                alu_control <= "0000";

                wait for period;

                alu_control <= "0001";

                wait for period;

                alu_control <= "0010";

                wait for period;

                alu_control <= "0011";

                wait for period;

                alu_control <= "0100";


                wait for period;

                src_b <= "11111111100000000000000000000000";
                src_a <= "11111111111111111111111111111111";

                alu_control <= "0100";

                wait for period;

                src_a <= "11111111111111111111111111111111";
                shift_amount <= "000100";
                alu_control <= "0101";

                wait for period;

                src_a <= "11111111111111111111111111111111";
                src_b <= "11111111111111111111111111111111";

                alu_control <= "0001";

            end process;

end tb;
