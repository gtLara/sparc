library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity tb_control is
end tb_control;

architecture tb of tb_control is

    -- declaracao de unidade de controle

        component control is
            port(
                 opcode : in std_logic_vector(5 downto 0);
                 format : in std_logic_vector(1 downto 0);
                 data_we : out std_logic;
                 branch : out std_logic;
                 register_we : out std_logic;
                 alu_control : out std_logic_vector(3 downto 0));
        end component;

        -- inputs

        signal opcode : std_logic_vector(5 downto 0) := (others => '0');
        signal format : std_logic_vector(1 downto 0) := (others => '0');

        -- outputs

        signal branch : std_logic;
        signal register_we : std_logic;
        signal data_we : std_logic;
        signal alu_control : std_logic_vector(3 downto 0);

        begin

        -- instancia unidade sob teste

        uut: control port map(
                              opcode => opcode,
                              format => format,
                              data_we => data_we,
                              branch => branch,
                              register_we => register_we,
                              alu_control => alu_control
                             );

        -- executa testbench, variando entradas para verificar saidas

        test_bench: process

            constant period: time := 100 ns;
            begin
                
                wait for period;

                -- ld control

                opcode <= "000000";
                format <= "11";

                wait for period;

                -- add control

                opcode <= "000000";
                format <= "10";

                wait for period;

                -- and control

                opcode <= "010001";
                format <= "10";

                wait for period;

                -- xor control

                opcode <= "000111";
                format <= "10";

                wait for period;

                -- srl control

                opcode <= "100110";
                format <= "10";

                wait for period;

                -- subcc control

                opcode <= "010100";
                format <= "10";

                wait for period;

                -- subcc control

                opcode <= "010100";
                format <= "10";

                wait for period;

                -- subcc control

                format <= "00";

            end process;

end tb;
