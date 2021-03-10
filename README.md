# Documentação
## Introdução: arquitetura SPARC e o trabalho desenvolvido
A arquitetura SPARC(Scalable Processor ARChitecture) é uma arquitetura aberta RISC criada em 1987 pela SUN Microsystems. Ela  se tornou muito popular e até hoje é amplamente utilizada. Neste trabalho usaremos a versão 8 da SPARC, de 32 bits como inspiração para fazer um processador ciclo único que execute um algoritmo simples de teste de paridade de bits.
## Características da arquitetura mais relevantes para nossa aplicação:
##### Banco de registradores de tamanho variável
São 8 registradores globais + N janelas de 16 registradores sobrepostas. Uma implementação pode ter de 40 registradores (duas janelas) até 520 registradores (32 janelas). Como há sobreposição de registradores, mostrado nas figuras `X` e `Y`, o número de unidades no hardware é menor. Mais informações sobre as imagens no documento referenciado.\
![sobreposicao_regs](https://github.com/gtLara/sparc/blob/master/images/sobreposi%C3%A7%C3%A3o_regs.jpg) ![roda_das_janelas](https://github.com/gtLara/sparc/blob/master/images/Roda_das_janelas.jpg)
##### Dois registradores Program Counter 
A arquitetura SPARC prevê dois Program Counters: nPC e PC. PC guarda o endereço da instrução a ser executada no ciclo, enquanto nPC guarda o endereço da instrução seguinte.
##### Branch com comparação anterior e instrução atrasada
As intruções de Branch na arquitetura envolvem outras duas instruções. A primeira é uma pseudoinstrução de comparação, `cmp`, que subtrai dois operandos e armazena 4 valores referentes a essa operação, como  existência overflow ou resultado negativo, em um registrador específico, o registrador de estados do processador.  Esses quatro valores serão utilizados como condição para o desvio pela própria instrução de branch (`bl` por exemplo). A segunda é uma instrução que fica logo depois da instrução de branch e pode ou não ser executada. Isso é possível porque o branch altera nPC, e não PC.
##### Demais características
Diversas características da arquitetura SPARC não foram citadas por não serem relevantes em nossa aplicação. Entre elas: Coprocessador, Unidade de Ponto Flutuante, Registradores de Estado, Traps, etc.
## Algoritmo utilizado
O algoritmo de teste de paridade é bastante simples.  Ele retorna o resultado '1' caso o número de bits '1' no dado de 8 bits seja par e '0' caso seja ímpar. Para computar tal resultado, basta fazer a operação XOR do bit de paridade (inicialmente em '1', já que foi utilizada a paridade par) com cada bit do dado, um após o outro. A seguir estão os códigos implementados em C e em Assembly.
```
Código em C


/*
 * Programa de teste de paridade: crc = 1 paridade par e crc = 0 paridade ímpar
 */
#include <stdio.h>

boolean crc(){
  int crc = 1;//se tudo for zero, o crc não se altera e a paridade é par
  int dados = 0xfb;//somente 8 bits são usados
  for(int i = 0; i < 8; i++){
    //faz XOR do CRC com o bit i dos dados (começando do bit zero)
    /*
     * exemplo
     * dados = 0xfb;
     * dados >> 2 = 0x3e;
     * ( (dados >> 2) & 0x1 ) = 0;
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

! dilaceramos o banco de registradores, só usamos 32 + 1:
! %g0 ~ %g7 = %r0  ~ %r7   - registradores globais
! %o0 ~ %07 = %r8  ~ %r15  - registradores Out
! %l0 ~ %l7 = %r16 ~ %r23 - registradores locais
! %i0 ~ %i7 = %r24 ~ %r31 - registradores in
! %g0 = %r0 = constante 0
! %psr - registrador de estado, usa ele no bl
! tem o PC tbm, mas ele sempre existe

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
(listar os operações que a ALU faz e foto com a "pinagem")
##### Banco de registradores
(leitura assíncrona e escrita síncrona com enable, etc. "pinagem")
##### Unidade de Controle
(só "pinagem" já serve)
##### Memórias
(endereçamento, etc)
##### Extensor de sinal
(só os pinos)
##### Somador
(com ou sem sinal, qtos bits)
##### PC
(qtos bits, se tem enable)
##### PSR 
(qtos bits, se tem enable)
## Resultados e simulações
## Referências
The SPARC Architecture Manual, Version 8, disponível em [https://sparc.org/](https://sparc.org/).
