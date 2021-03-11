library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity shifter is
    port(
         src : in std_logic_vector(31 downto 0);
         shift : out std_logic_vector(31 downto 0));
end shifter;

architecture shifter_arc of shifter is
    begin
        shift <= std_logic_vector(unsigned(src) sll 2);
        -- casting para evitar problemas resultantes do fato de que
        -- apenas VHDL 2008+ aceita sll em std_logic_vector
end shifter_arc;
