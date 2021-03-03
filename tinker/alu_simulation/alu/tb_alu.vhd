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
            src_a : in std_logic_vector(3 downto 0);
            src_b: in std_logic_vector(3 downto 0);
            alu_control : in std_logic_vector(1 downto 0);
            alu_result : out std_logic_vector(3 downto 0);
            zero : out std_logic);
    end component;

    -- inputs

    signal src_a : std_logic_vector(3 downto 0) := (others => '0');
    signal src_b : std_logic_vector(3 downto 0) := (others => '0');
    signal alu_control : std_logic_vector(1 downto 0) := (others => '0');
    
    -- outputs

    signal alu_result : std_logic_vector(3 downto 0);
    signal zero : std_logic;

    begin

    -- instancia unidade sob teste

    uut: alu port map(
                        src_a => src_a,
                        src_b => src_b,
                        alu_control => alu_control,
                        alu_result => alu_result,
                        zero => zero);
    
    -- executa testbench, variando entradas para verificar saidas

    test_bench: process
        constant period: time := 100 ns;
        begin
            wait for period;

            src_a <= "1111";

            wait for period;
            
            alu_control <= "01";
            src_b <= "1111";

            wait for period;

            alu_control <= "11";
            src_a  <= "1010";

            wait for period;

            alu_control <= "10";
            src_b  <= "1010";
            src_a  <= "1110";

            wait for period;

        end process;

end tb;

-- TODO: investigar erro em output "zero"
