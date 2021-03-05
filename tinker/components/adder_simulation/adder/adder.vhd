library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity adder is
    port(
         src_a : in std_logic_vector(31 downto 0);
         src_b : in std_logic_vector(31 downto 0);
         sum : out std_logic_vector(31 downto 0));
end adder;

architecture adder_arc of adder is
    begin
        sum <= src_a + src_b;
end adder_arc;
