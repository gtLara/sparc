library IEEE;
use IEEE.std_logic_1164.all;

entity mux is
    port(
            a, b, c, d : in std_logic_vector(31 downto 0);
            sel : in std_logic_vector(1 downto 0);
            e : out std_logic_vector(31 downto 0));
end mux;

architecture mux_arc of mux is
    begin
    with sel select
        e <= a when "00",
             b when "01",
             c when "10",
             d when "11",
             "--------------------------------" when others;
end mux_arc;
