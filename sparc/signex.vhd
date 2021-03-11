library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

-- extensor de sinais, extende sinal de tamanho generico para 32 bits

entity signex is
    generic(size: integer := 12); -- na verdade é tamanho - 1
    port(
         signex_in: in std_logic_vector(size downto 0);
         signex_out: out std_logic_vector(31 downto 0));
end signex;

architecture signex_arc of signex is
    constant one : std_logic := '1';
    constant zero : std_logic := '0';
    constant ones_extension : std_logic_vector(31 - size - 1 downto 0) := (others => '1');
    constant zeros_extension : std_logic_vector(31 - size - 1 downto 0) := (others => '0');
    constant u_vec : std_logic_vector(31 downto 0) := (others => 'U');

    begin
        with (signex_in(size)) select
            signex_out <= ones_extension & signex_in when one,
                          zeros_extension & signex_in when zero,
                          u_vec when others;

end signex_arc;
