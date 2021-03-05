library IEEE;
use IEEE.std_logic_1164.all;

entity mux is
    port(
            a, b : in std_logic_vector(31 downto 0);
            sel : in std_logic;
            e : out std_logic_vector(31 downto 0));
end mux;

architecture mux_arc of mux is
    constant u_vec : std_logic_vector(31 downto 0) := (others => 'U');
    begin
    with sel select
        e <= a when '0',
             b when '1',
             u_vec when others;
end mux_arc;
