library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity sparc is
    port(
        clk : in std_logic;
        reset : in std_logic;
        rd_1 : in std_logic_vector(31 downto 0);
        rd_2 : in std_logic_vector(31 downto 0)
        ra_1 : in std_logic_vector(4 downto 0);
        ra_2 : in std_logic_vector(4 downto 0)
        );
end sparc;


architecture sparc_arc of sparc is

    --------------------------------------------------------------------------
    -- Declaracao de componentes ---------------------------------------------
    --------------------------------------------------------------------------

    component signex is
        port(
             signex_in: in std_logic_vector(12 downto 0);
             signex_out: out std_logic_vector(31 downto 0));
    end component;

    component mux is
        port(
             a, b : in std_logic_vector(31 downto 0);
             sel : in std_logic;
             e : out std_logic_vector(31 downto 0));
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

    component register_file is -- registrador de 32 palavras

        port(
             ra_1, ra_2, wa_3 : in std_logic_vector(4 downto 0);
             clk : in std_logic;
             we : in std_logic;
             wa_3_data : in std_logic_vector(31 downto 0);
             ra_1_data, ra_2_data : out std_logic_vector(31 downto 0)
            );

    end component;

    --------------------------------------------------------------------------
    -- Declaracao de sinais --------------------------------------------------
    --------------------------------------------------------------------------

    -- DUMMIES

    signal instruction : std_logic_vector(31 downto 0) := "00000010000000000011010101010101";

    -- imediato

    signal imm : std_logic_vector(12 downto 0) := instruction(12 downto 0);

    -- registrador destino

    signal rd : std_logic_vector(4 downto 0) := instruction(29 downto 25);

    -- registrador fonte 1

    signal rs_1 : std_logic_vector(4 downto 0) := instruction(18 downto 14);

    -- registrador fonte 2

    signal rs_2 : std_logic_vector(4 downto 0) := instruction(4 downto 0);

    -- i: 1 para instrucao imediata e 0 caso contrario
    
    signal i: std_logic := instruction(13);

    -- o restante da instrucao vai para controle

    -- sinais de banco de registradores

    signal ra_1_data, ra_2_data, wa_3_data : std_logic_vector(31 downto 0) := (others => '0');
    signal we : std_logic := '1'; -- essa informacao deve ser preenchida por controle

    -- sinais de alu

    signal shift_amount: std_logic_vector(5 downto 0) := (others => '0');
    signal alu_control : std_logic_vector(3 downto 0) := "0011"; -- CONTROL
    signal zero : std_logic;

    -- sinais de mux

    signal alu_mux_out: std_logic_vector(31 downto 0);
    signal alu_mux_sel: std_logic;

    --------------------------------------------------------------------------
    -- Definicao de datapath -------------------------------------------------
    --------------------------------------------------------------------------

    begin

    -- pensar em como implementar PC; iteracao +4 requer alteracao de
    -- enderecamento em banco de registros, que no momento esta por inteiro

    --------------------------------------------------------------------------
    -- Instanciacao de componentes -------------------------------------------
    --------------------------------------------------------------------------

    -- instancia de banco de registradores

    u_register_file: register_file port map(
                                             ra_1 => rs_1,
                                             ra_2 => rs_2,
                                             wa_3 => rd,
                                             clk => clk,
                                             we => we,
                                             wa_3_data => wa_3_data,
                                             ra_1_data => ra_1_data,
                                             ra_2_data => ra_2_data);
    -- instancia de extensor de sinais

    u_signex: signex port map(
                             signex_in =>  imm, -- signex_in
                             signex_out =>  signex_out -- signex_out
                             );
    
    -- instancia de mux de alu

    u_alu_mux: mux port map(
                            a => ra_2_data, -- mux_in_1
                            b => signex_out, -- mux_in_2
                            sel => i, -- mux_sel
                            e  => alu_mux_out); -- mux_out

    -- instancia de alu

    u_alu: alu port map(
                        src_a => ra_1_data,
                        src_b => alu_mux_out,
                        shift_amount => shift_amount,
                        alu_control => alu_control,
                        alu_result => wa_3_data,
                        zero => zero
                     );

end sparc_arc;
