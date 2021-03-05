library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity sparc is
    port(
        clk : in std_logic;
        reset : in std_logic
        );
end sparc;


architecture sparc_arc of sparc is

    component signex is
        port(
             a: in std_logic_vector(15 downto 0);
             b: out std_logic_vector(31 downto 0));
    end component;

    component shifter is
        port(
             src : in std_logic_vector(31 downto 0);
             shift : out std_logic_vector(31 downto 0));
    end component;

    component mux is
        port(
                a, b : in std_logic_vector(31 downto 0);
                sel : in std_logic;
                e : out std_logic_vector(31 downto 0));
    end component;

    component adder is
        port(
             src_a : in std_logic_vector(31 downto 0);
             src_b : in std_logic_vector(31 downto 0);
             sum : out std_logic_vector(31 downto 0));
    end component;

    component alu is
    port(
        src_a : in std_logic_vector(31 downto 0); -- entrada a
        src_b: in std_logic_vector(31 downto 0); -- entraba b
        shift_amount: in std_logic_vector(5 downto 0); -- quantidade de deslocamento: pode deslocar 32 bits
        alu_control : in std_logic_vector(3 downto 0); -- controle de operação
        alu_result : out std_logic_vector(31 downto 0); -- resultado de operação
        zero : out std_logic); -- bandeira que indica se resultado foi zero

    end component;

    -- sinais de alu
    
    signal src_a, src_b, alu_result : std_logic_vector(31 downto 0);
    signal shift_amount: std_logic_vector(5 downto 0); 
    signal alu_control : std_logic_vector(3 downto 0);
    signal zero : std_logic;

    begin

    -- pensar em como implementar PC; iteracao +4 requer alteracao de
    -- enderecamento em banco de registros, que no momento esta por inteiro

    -- instancia de alu
    
    u_alu: alu port map(
                        src_a => src_a,
                        src_b => src_b,
                        shift_amount => shift_amount,
                        alu_control => alu_control,
                        alu_result => alu_result,
                        zero => zero
                     );

end sparc_arc;
