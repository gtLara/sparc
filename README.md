# Documentação

## Introdução: arquitetura SPARC e o trabalho desenvolvido

A arquitetura SPARC(Scalable Processor ARChitecture) é uma arquitetura aberta
RISC criada em 1987 pela SUN Microsystems. Ela  se tornou muito popular e até
hoje é amplamente utilizada. Neste trabalho usaremos a versão 8 da SPARC, de 32
bits como inspiração para fazer um processador ciclo único que execute um
algoritmo simples de teste de paridade de bits.
## Características da arquitetura mais relevantes para nossa aplicação:
##### Banco de registradores
de tamanho variável São 8 registradores globais + N janelas de 16 registradores
sobrepostas. Uma implementação pode ter de 40 registradores (duas janelas) até
520 registradores (32 janelas). Como há sobreposição de registradores, mostrado
nas figuras `X` e `Y`, o número de unidades no hardware é menor. Mais
informações sobre as imagens no documento referenciado.\
![sobreposicao_regs](https://github.com/gtLara/sparc/blob/master/images/sobreposi%C3%A7%C3%A3o_regs.jpg)
![roda_das_janelas](https://github.com/gtLara/sparc/blob/master/images/Roda_das_janelas.jpg)\
Figuras mostrando a organização dos registradores na arquitetura SPARC.
##### Dois registradores Program Counter A arquitetura SPARC prevê dois Program

Counters: nPC e PC. PC guarda o endereço da instrução a ser executada no ciclo,
enquanto nPC guarda o endereço da instrução seguinte.


##### Branch com comparação anterior e instrução atrasada

As intruções de Branch na arquitetura envolvem outras duas instruções. A
primeira é uma pseudoinstrução de comparação, `cmp`, que subtrai dois operandos
e armazena 4 valores referentes a essa operação, como  existência overflow ou
resultado negativo, em um registrador específico, o registrador de estados do
processador.  Esses quatro valores serão utilizados como condição para o desvio
pela própria instrução de branch (`bl` por exemplo). A segunda é uma instrução
que fica logo depois da instrução de branch e pode ou não ser executada. Isso é
possível porque o branch altera nPC, e não PC.

##### Demais características

Diversas características da arquitetura SPARC não foram citadas por não serem
relevantes em nossa aplicação. Entre elas: Coprocessador, Unidade de Ponto
Flutuante, Registradores de Estado, Traps, etc.

## Algoritmo utilizado

O algoritmo de teste de paridade é bastante simples.  Ele retorna o resultado '1'
caso o número de bits '1' no dado de 8 bits seja par e '0' caso seja ímpar.
Para computar tal resultado, basta fazer a operação XOR do bit de paridade
(inicialmente em '1', já que foi utilizada a paridade par) com cada bit do
dado, um após o outro. A seguir estão os códigos implementados em C, assembly e
linguagem de máquina.

```C
Código em C

/*
 * Programa de teste de paridade: crc = 1 paridade par e crc = 0 paridade ímpar
 */
#include <stdio.h>

boolean crc(){
  int crc = 1;//se tudo for zero, o crc não se altera e a paridade é par
  int dados = 0x04;//somente 8 bits são usados
  for(int i = 0; i < 8; i++){
    //faz XOR do CRC com o bit i dos dados (começando do bit zero)
    /*
     * exemplo
     * dados = 0x04;
     * dados >> 2 = 0x01;
     * ( (dados >> 2) & 0x1 ) = 1;
     *
     */
    crc ^= (dados & 0x1);
    dados = dados>>1;
  }
  return crc;
}
```

```
Código em Assembly do SPARC


! Instruções a serem usadas:
! ld - pra iniciar variáveis
! add - pro for
! cmp a,b = subcc a, b, %g0 - para mudar o icc e usar o bl
! bl,a - "Branch on Less" com annul ",a" pro for
! srl
! xor
! and

! banco de registradores reduzido: 32 de uso geral + 2 de estado:
! %g0 ~ %g7 = %r0  ~ %r7   - registradores globais
! %o0 ~ %07 = %r8  ~ %r15  - registradores Out
! %l0 ~ %l7 = %r16 ~ %r23 - registradores locais
! %i0 ~ %i7 = %r24 ~ %r31 - registradores in
! %g0 = %r0 = constante 0
! de estado:
! %psr - registrador de estado, usa ele no bl
! PC - Program Counter 

!seções devem ser iniciadas assim:
.section ".data"
    dados:  .word 4    !dado de 8bits a ser analisado
    crc:    .word 1    !se dados = 0, crc = 1 e paridade par

.section ".text"

main:   ld crc , %l0        ! traz os dados da memória de dados
        ld dados , %l1      ! para os registradores locais

        add %g0, 0, %l7   ! inicia %l7 = i = 0

for:    and %l1, 1, %l2     ! pega o LSB do dados atual e poe em %l2
        xor %l0, %l2, %l0   ! atualiza o crc com o bit de dados
        srl %l1, 1, %l1     ! dados >>= 1

        add %l7, 1, %l7     ! incrementa i
        cmp %l7 , 8         ! compara i com 8 e modifica o icc
        bl for; nop         ! se i < 8 volta pro for, a instrução de delay tem que existir de qualquer jeito,
                            ! mas a gente vai ignorar isso no caminho de dados
!FIM, o resultado com crc fica em %l0
```
```
Linguagem de Máquina:
Instrução 0 - 11100000000000000010000000000001
Instrução 1 - 11100010000000000010000000000000
Instrução 2 - 10101110000000000010000000000000
Instrução 3 - 10100100100011000110000000000001
Instrução 4 - 10100000001111000000000000010010
Instrução 5 - 10100011001101000110000000000001
Instrução 6 - 10101110000001011110000000000001
Instrução 7 - 10000000101001011110000000001000
Instrução 8 - 00000110100000000000000000000011
```
## Decisões de projeto

De maneira geral, as decisões de projeto foram tomadas tendo em vista a construção do mínimo de componentes necessário para a execução do algoritmo. As principais decisões estão listadas a seguir:
1. Como usaremos uma quantidade muito pequena de registradores e não precisaremos de mudar de contexto em momento algum, reduzimos o banco de registradores para 32 registradores, havendo só uma janela. São 8 globais (%g0 ~ %g7) e 24 de uso geral em três blocos de 8 (%o0 ~%o7, %l0 ~ %l7, %i0 ~ %i7).
2. Nosso processador é ciclo único e, por isso, adaptamos o Program Counter e a instrução de branch. Sem a presença de um pipeline não é preciso aguardar o branch ser calculado e executar outra instrução enquanto isso. O registrador nPC foi retirado, ficando apenas PC, e o branch passou a modificar diretamente PC, diferentemente de antes, que modificava nPC.
3. Usamos apenas um registrador de estado, o Processor State Register, e dele aproveitamos apenas um bit. O bit aproveitado (N) indica se o resultado da última operação da ALU foi negativo e é usado para decidir se o branch será tomado ou não.
4. O manual dava liberdade de implementar tanto uma memória única para dados e instruções quanto usar duas memórias separadas. Optamos por separar a memória de dados da memória de instruções.
5. O conjunto de operações da ALU foi reduzido para atender às nossas necessidades.

## Implementação do processador

O processador foi implementado em linguagem VHDL e verificado utilizando o ModelSim. A figura `X` mostra o processador desenvolvido com o caminho de dados e a unidade de controle.\
(imagem)\
Em seguida uma breve descrição de cada componente. (uma frase pra cada um, nada longo demais)

##### ALU
Declaração em VHDL:
```VHDL
entity alu is
    port(
        src_a : in std_logic_vector(31 downto 0); -- entrada a
        src_b: in std_logic_vector(31 downto 0); -- entraba b
        shift_amount: in std_logic_vector(4 downto 0); -- quantidade de deslocamento: pode deslocar 32 bits
        alu_control : in std_logic_vector(3 downto 0); -- controle de operação
        alu_result : out std_logic_vector(31 downto 0); -- resultado de operação
        negative: out std_logic; -- sinaliza se resultado foi negativo
        zero : out std_logic); -- bandeira que indica se resultado foi zero

end alu;
```
A ALU implementada realiza as operações listadas na tabela a seguir. Ao
lado esquerdo do nome da operação está seu identificador binário.

| op_id  | operacao            |
|--------|---------------------|
| 0000   | soma                |
| 0001   | subtração           |
| 0010   | and                 |
| 0011   | or                  |
| 0100   | xor                 |
| 0111   | shift right logical |

Observa-se que duas outras operações foram implementadas mas não usadas no
processador (portanto omitidas).

A ALU calcula a operação desejada entre dois sinais de 32 bits, retornando o
resultante em um sinal de igual profundidade.

Além de ter como saída o resultado da operação a ALU sinaliza se o resultado
foi negativo. Isso é importante para a instrução de desvio condicional, que
funciona armazenando um sinal que indica se a última operação realizada foi
negativa no registrador "psr".

##### Banco de registradores
Declaração em VHDL:
```VHDL
entity register_file is -- registrador de 32 palavras

    port(
         ra_1, ra_2, wa_3 : in std_logic_vector(4 downto 0); -- entradas com endereço
         clk : in std_logic;
         we : in std_logic; -- write enable
         wa_3_data : in std_logic_vector(31 downto 0); -- entrada de dados de escrita
         ra_1_data, ra_2_data : out std_logic_vector(31 downto 0) -- saída de dados de leitura
        );

end register_file;
```
Mesmo modelo utilizado no livro-texto da disciplina, com leitura assíncrona e escrita síncrona.

##### Unidade de Controle
Declaração em VHDL:
```VHDL
entity control is
    port(
         opcode : in std_logic_vector(5 downto 0);
         format : in std_logic_vector(1 downto 0);
-- sinal que determina se ocorre escrita em memoria de dados
         data_we : out std_logic;
-- sinal que determina se pode ocorrer um branch (depende adicionalmente da saida negativa da alu. vide documentacao)
         branch : out std_logic;
-- sinal que determina se ocorre escrita nos registradores
         register_we : out std_logic;
-- sinal que determina a fonte do dado a ser escrito nos registradores (entre saida da memoria de dados ou da alu)
         regwrite_source : out std_logic;
-- sinal que determina se ocorre escrita no psr
         psr_we : out std_logic;
-- sinal que determina a operacao da alu
         alu_control : out std_logic_vector(3 downto 0));
end entity;
```
A unidade de controle é responsável por controlar permissões de escrita e
os vários mutliplexadores distribuídos no datapath para a execução das
instruções. A unidade recebe como entrada os sinais "opcode" e "format".

A tabela de verdade para a unidade de controle é apresentada a seguir:

| Mnemônico | opcode | format | data_we | register_we | branch | regwrite_source | psr_we | alu_control |
|-----------|--------|--------|---------|-------------|--------|-----------------|--------|-------------|
| ld        | 00000  | 11     | 0       | 1           | 0      | 1               | 0      | 0000        |
| add       | 00000  | 10     | 0       | 1           | 0      | 0               | 0      | 0000        |
| and       | 010001 | 10     | 0       | 1           | 0      | 0               | 0      | 0010        |
| xor       | 000111 | 10     | 0       | 1           | 0      | 0               | 0      | 0100        |
| srl       | 100110 | 10     | 0       | 1           | 0      | 0               | 0      | 0111        |
| subcc     | 010100 | 10     | 0       | 1           | 0      | 0               | 1      | 0001        |
| bl        | xxxxxx | 00     | x       | x           | 1      | x               | 0      | xxxx        |

O destino e a função de cada um dos sinais de saída é detalhado de forma
visual na ilustração do datapath desenvolvido.

##### Memórias
- De dados\
Declaração em VHDL:
```VHDL
entity data_memory is -- memoria de dados de 32 palavras

    port(
         data_address: in std_logic_vector(4 downto 0); -- data address
         clk : in std_logic;
         we : in std_logic; -- write enable
         write_data : in std_logic_vector(31 downto 0);
         data : out std_logic_vector(31 downto 0)
        );

end data_memory;
``` 
A memória de dados possui entrada e saída de dados, com entrada de endereço e de habilitação de esccrita.
- De instrução\
Declaração em VHDL:
```VHDL
entity instruction_memory is

    port(
            set : in std_logic; -- sinal para carregamento de progrma
            address : in std_logic_vector(4 downto 0);
            instruction : out std_logic_vector(31 downto 0));

end instruction_memory;
```
Como nunca há escrita na memória de instrução, ela possui apenas entrada de endereço e saída assíncrona. O sinal set é usado somente para iniciar a memória por meio de um testbench.



##### Extensor de sinal
Declaração em VHDL:
```VHDL
entity signex is
    generic(size: integer := 12); -- na verdade é tamanho - 1
    port(
         signex_in: in std_logic_vector(size downto 0);
         signex_out: out std_logic_vector(31 downto 0));
end signex;
```
Extende em sinal o imediato de 13 bits.
##### Somador
Declaração em VHDL:
```VHDL
entity adder is
    port(
         src_a : in std_logic_vector(4 downto 0);
         src_b : in std_logic_vector(4 downto 0);
         sum : out std_logic_vector(4 downto 0));
end adder;
```
Somador com sinal, para o endereço de PC. Note que PC foi reduzido e usa somente 5 bits.
##### PC
Descrição em VHDL:
```VHDL
entity program_counter is -- registrador que armazena endereços de instruções

    port(
         next_instruction_address : in std_logic_vector(4 downto 0);
         clk : in std_logic;
         current_instruction_address : out std_logic_vector(4 downto 0)
        );

end program_counter;
```
Registrador de 5 bits com entrada paralela.
##### PSR
Declaração em VHDL:
```VHDL
entity ps_register is -- registrador que armazena se ultima operacao da alu foi negativa

    port(
         psr_we : in std_logic; -- write enable
         next_input : in std_logic;
         clk : in std_logic;
         last_input : out std_logic
        );

end ps_register;
```
Só é usado 1 bit desse registrador, então ele foi reduzido.

### Notas sobre e execução

O trabalho foi desenvolvido inteiramente com o ModelSim gratuito distribuído
para linux. Optou-se por desenvolver e verificar, por meio de códigos de
testbench, cada componente usado no processador antes de iniciar a
integração. Cada componente e seus respectivos testbenches estão armazenados
em "tinker/components". A verificação dos componentes e do processo de
integração do processador, assim como a execução do programa armazenado em
memória, foram feitas no simulador oferecido pelo ModelSim.

A execução do programa em memória deve portanto ser feita abrindo o ModelSim,
abrindo o testbench compilado "sparc/work/tb_sparc", e executando o arquivo
.do projetado para essa execução, clean_test.do, por meio do comando
"do clean_test.do" no console do ModelSim.

A seguinte seção exemplifica um processo simples de acompanhamento da execução
do programa em memória.

## Resultados e simulações

Ao executar "do clean_test.do" observa-se a seguinte figura na janela
de visualização de onda:

![painel_onda](https://github.com/gtLara/sparc/blob/master/images/wave_panel.png)

Os sinais ao lado esquerdo da imagem foram escolhidos como os mais relevantes
para análise do processamento do programa armazenado, mas é possível visualizar
todos os sinais executando "do test.do".

O primeiro grupo de sinais a ser comentado são
"u_instruction_memory/instruction",
"u_program_counter/current_instruction_address" e
"u_program_counter/next_instruction_address, que representam a instrução
associada ao ciclo atual, o endereço de tal instrução e o endereço da próxima
instrução, respectivamente.

Com esse trio de sinais já é possível monitorar o funcionamento adequado do
mecanismo de desvio condicional desenvolvido para implementar o laço "for" do
programa em alto nível. A linha amarela vertical na imagem abaixo indica um
evento em que o endereço de um salto é calculado e selecionado. Observe que
"next_instruction_address" deixa de se incrementar consecutivamente e passa de
8 para 3, retornando a execução ao início do laço. A instrução em si de fato se
altera para a instrução presente no endereço 3 da memória de instrução.

![exemplo_branch](https://github.com/gtLara/sparc/blob/master/images/branch_example.png)

Outros conjunto de sinais importante para o acompanhamento dos branches são
a entrada e saídas da porta and que determina um branch, "u_branch_and/".
A saída dessa porta, "u_branch_and/and_out", sinaliza se o branch foi
tomado de fato. A imagem abaixo ilustra o momento em que um branch ocorre.

![exemplo_branch](https://github.com/gtLara/sparc/blob/master/images/branch_example_abd.png)

Nesse ponto é interessante observar a saída da versão em C do programa que o
processador executa. Recorre-se como referência ao código "paridade.c".
Imprimindo os valores das variáveis "crc" e "dado" a cada iteração do loop do
CRC obtém-se a seguinte saída:

![sobreposicao_regs](https://github.com/gtLara/sparc/blob/master/images/c_out.png)

Uma vez que esse é exatamente o programa escrito em linguagem de máquina na
memória de instruções assume-se como condição suficiente para conclusão que o
processador foi implementado com sucesso a observação dos mesmos valores nas
variáveis relevantes durante a simulação de execução do program armazenado.

Para tal observação é necessário se atentar ao sinal que representa a memória
dos registradores, "u_register_file/mem". A imagem abaixo mostra um estado
intermediário desse sinal, onde se espera encontrar "crc = 1" e "dado = 2".

![exemplo_branch](https://github.com/gtLara/sparc/blob/master/images/register.png)

Sabendo que os registradores em que os dados mencionados são armazenados são
(em decimal) 16 e 17, respectivamente, nota-se que nossa expectativa é
atendida.

A verificação de que os valores seguintes desses registradores se comportam
como esperado pode ser feito da mesma maneira. A imagem a seguir ilustra
o estado final da memória de registradores.

![exemplo_branch](https://github.com/gtLara/sparc/blob/master/images/final_register.png)

Para finalizar a análise dos registradores nota-se que o registrador 23,
responsável por armazenar a variável "i", armazena 8 como esperado.

Por fim chama-se atenção aos sinais de controle, ilustrados em um dado
momento da execução na imagem a seguir.

![exemplo_branch](https://github.com/gtLara/sparc/blob/master/images/control.png)

Como já mencionado o arquivo "clean_test.do" carrega outros sinais em sua
representação numérica apropriada que foram considerados importantes para a
análise brevemente descrita nessa seção.

### Nota sobre encerramento

O encerramento da execução do programa é feito no arquivo "clean_test.do" por
meio das seguintes linhas:

```
when {sim:/tb_sparc/uut/u_program_counter/next_instruction_address == "01010"} {
  stop
  echo "Programa chegou ao fim"
}
```

Que simplesmente encerra o programa se o endereço da próxima instrução for
igual a 10, isso é, se a condição pra o branch falhar, evento correspondente
à saída do laço for. A imagem a seguir ilustra a saída no console indicando
a parada.

![exemplo_branch](https://github.com/gtLara/sparc/blob/master/images/end.png)

## Referências
The SPARC Architecture Manual, Version 8, disponível em [https://sparc.org/](https://sparc.org/)\
Apresentação de slides do curso CS217 - Programing Systems de Princeton
- [https://www.cs.princeton.edu/courses/archive/spring02/cs217/lectures/sparc.pdf](https://www.cs.princeton.edu/courses/archive/spring02/cs217/lectures/sparc.pdf)
- [https://www.cs.princeton.edu/courses/archive/spring03/cs217/lectures/Branching.pdf](https://www.cs.princeton.edu/courses/archive/spring03/cs217/lectures/Branching.pdf) 
