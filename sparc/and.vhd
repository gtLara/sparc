library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity and_gate is
    port( and_in_a : in std_logic;
          and_in_b : in std_logic;
          and_out : out std_logic
        );
end and_gate;

architecture and_arc of and_gate is
begin
    and_out <= and_in_a AND and_in_b;
end and_arc;
