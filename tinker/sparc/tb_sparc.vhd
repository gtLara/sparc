library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity tb_sparc is
end tb_sparc;

architecture tb of tb_sparc is

    component sparc is
        port(
            clk : in std_logic;
            reset : in std_logic
            );
    end component;


    begin

    -- para inciar desenvolvimento de tb precisa de algum tipo de controle!

end tb;
