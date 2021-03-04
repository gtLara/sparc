library IEEE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity alu is
    port(
        src_a : in std_logic_vector(31 downto 0);
        src_b: in std_logic_vector(31 downto 0);
        alu_control : in std_logic_vector(3 downto 0);
        alu_result : out std_logic_vector(31 downto 0);
        zero : out std_logic);

end alu;

architecture alu_arc of alu is

signal result : std_logic_vector(31 downto 0);
constant all_zeros : std_logic_vector(31 downto 0) := (others => '0');

begin
    alu_process: process(alu_control, src_a, src_b)
        begin
            case (alu_control) is

                when "0000" => result <= src_a + src_b; -- soma
                when "0001" => result <= src_a - src_b; -- subtracao
                when "0010" => result <= src_a OR src_b; -- or
                when "0011" => result <= src_a XOR src_b; -- xor
                when "0100" =>                            -- set less than
                    if (src_a < src_b) then
                        result <= all_zeros;
                        result(0) <= '1';
                    else
                        result <= all_zeros; -- pega caso de igualdade!
                    end if;

                -- tratar mais casos se necessario

                when others => null; -- no op 
                    result <= "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU";

            end case;

            -- saida zero se o resultado for zero

        end process;

        alu_result <= result;

        zero <= '1' when result = all_zeros else
                '0';

end alu_arc;
