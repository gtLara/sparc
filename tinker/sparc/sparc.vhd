-- TODO: implementar datapath expandido, program counter, carregar
-- programa, pensar sobre enderecamento 
--
--
--
--
--
--
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity sparc is
    port(
        clk : in std_logic;
        reset : in std_logic;
        set : in std_logic;
        -- control
        data_we : in std_logic;
        register_we : in std_logic;
        alu_control : in std_logic_vector(3 downto 0) --control signal
        );
end sparc;

architecture sparc_arc of sparc is

    --------------------------------------------------------------------------
    -- Declaracao de componentes ---------------------------------------------
    --------------------------------------------------------------------------
    
    component program_counter is
        port(
             next_instruction_address : in std_logic_vector(4 downto 0);
             clk : in std_logic;
             current_instruction_address : out std_logic_vector(4 downto 0)
            );
    end component;

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

    component data_memory is -- memoria de dados de 32 palavras

        port(
             data_address: in std_logic_vector(4 downto 0);
             clk : in std_logic;
             we : in std_logic;
             write_data : in std_logic_vector(31 downto 0);
             data : out std_logic_vector(31 downto 0)
            );

    end component;

    component adder is
        port(
             src_a : in std_logic_vector(4 downto 0);
             src_b : in std_logic_vector(4 downto 0);
             sum : out std_logic_vector(4 downto 0));
    end component;

    component instruction_memory is

        port(
                set : in std_logic;
                address : in std_logic_vector(4 downto 0);
                instruction : out std_logic_vector(31 downto 0));

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

    -- i: 1 para instrucao imediata e 0 caso contrario CONTROLE
    
    signal i: std_logic := instruction(13);

    -- o restante da instrucao vai para controle

    -- sinais de extensor de sinais

    signal signex_out : std_logic_vector(31 downto 0);

    -- sinais de banco de registradores

    signal ra_1_data, ra_2_data, wa_3_data : std_logic_vector(31 downto 0) := (others => '0');

    -- sinais de alu

    signal shift_amount: std_logic_vector(5 downto 0) := (others => '0');
    signal zero : std_logic;

    -- sinais de mux

    signal alu_mux_out: std_logic_vector(31 downto 0);
    signal alu_mux_sel: std_logic;

    -- sinais de memoria de dados

    signal data: std_logic_vector(31 downto 0);

    -- sinais de contador de programa e seu somador

    signal increment_of_one : std_logic_vector(4 downto 0) := "00001";
    signal current_instruction_address : std_logic_vector(4 downto 0) := "00000";
    signal pc_adder_out : std_logic_vector(4 downto 0); 

    --------------------------------------------------------------------------
    -- Definicao de datapath -------------------------------------------------
    --------------------------------------------------------------------------

    begin

    -- pensar em como implementar PC; iteracao +4 requer alteracao de
    -- enderecamento em banco de registros, que no momento esta por inteiro

    --------------------------------------------------------------------------
    -- Instanciacao de componentes -------------------------------------------
    --------------------------------------------------------------------------

    -- instancio do somador de contador de programa

    u_pc_adder: adder port map(
                                src_a => current_instruction_address, -- o bootstrap do processador é feito aqui: faz-se o drive da primeira instrução e ele se desenrola a partir disso
                                src_b => increment_of_one, 
                                sum  => pc_adder_out -- essa saida deve ir ao mux para beq
                               );

    -- instancia contador de programa

    u_program_counter: program_counter port map(
                                                clk => clk,
                                                next_instruction_address => pc_adder_out,
                                                current_instruction_address => current_instruction_address
                                                );
    
    -- instancia de memoria de instrucoes

    u_instruction_memory: instruction_memory port map(
                                                      set  => set,
                                                      address => current_instruction_address,
                                                      instruction => instruction
                                                     );

    -- instancia de banco de registradores

    u_register_file: register_file port map(
                                             ra_1 => rs_1,
                                             ra_2 => rs_2,
                                             wa_3 => rd,
                                             clk => clk,
                                             we => register_we,
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
                        alu_result => wa_3_data, -- saida de alu é mapeada para endereço de escrita de registrador ou dados. ver como generalizar nome desse sinal
                        zero => zero
                     );

    -- instancia de memoria de dados

    u_data_mem: data_memory port map(
                                     data_address => wa_3_data(4 downto 0), -- saida de alu; enderacamento eh feito em 5 bits
                                     clk => clk,
                                     we => data_we,
                                     write_data => ra_1_data,
                                     data => data
                                    );

end sparc_arc;
