library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity control is
    port(
         opcode : in std_logic_vector(5 downto 0);
         format : in std_logic_vector(1 downto 0);
         data_we : out std_logic;
         branch : out std_logic;
         register_we : out std_logic;
         regwrite_source : out std_logic;
         alu_control : out std_logic_vector(3 downto 0));
end entity;

architecture control_arc of control is

begin

    control: process(opcode, format)
        begin
            case (format) is

                when "11" => -- ld
                    alu_control <= "0000";
                    branch <= '0';
                    regwrite_source <= '1';

                when "10" =>-- arithmetic instructions
                    case(opcode) is

                        when "000000" => -- add
                            alu_control <= "0000";
                            branch <= '0';
                            regwrite_source <= '0';

                        when "010001" => -- and
                            alu_control <= "0010";
                            branch <= '0';
                            regwrite_source <= '0';

                        when "000111" => -- xor
                            branch <= '0';
                            alu_control <= "0100";
                            regwrite_source <= '0';

                        when "100110" => -- srl
                            alu_control <= "0111";
                            branch <= '0';
                            regwrite_source <= '0';

                        when "010100" => -- srl
                            alu_control <= "0001";
                            branch <= '0';
                            regwrite_source <= '0';

                        when others => null; -- deadcase

                    end case;

                when "00" =>
                    alu_control <= "0000";
                    branch <= '1';

                when others => null; -- deadcase

                end case;

            end process control;

            data_we <= '0';
            register_we <= '1';

end control_arc;
