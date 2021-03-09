# Documentação
## Introdução: arquitetura SPARC e o trabalho desenvolvido
A arquitetura SPARC(Scalable Processor ARChitecture) surgiu em 1987, desenvolvida pela SUN Microsystems. Essa arquitetura se tornou muito popular e até hoje é amplamente utilizada. A arquitetura é aberta e pode ser implementada por qualquer um. Neste trabalho usaremos a versão 8 da SPARC, de 32 bits como inspiração. Devemos fazer um processador ciclo único que execute um algoritmo simples de teste de paridade de bits.\
## Características da arquitetura mais relevantes para nossa aplicação:
##### Banco de registradores de tamanho variável
São 8 registradores globais + N janelas de 16 registradores sobrepostas. Uma implementação pode ter de 40 registradores (duas janelas) até 520 registradores (32 janelas). Como há sobreposição de registradores, mostrado nas figuras `X` e `Y`, o número de unidades no hardware é menor. Mais informações sobre as imagens no documento referenciado.\
![sobreposicao_regs](https://github.com/gtLara/sparc/blob/master/images/sobreposi%C3%A7%C3%A3o_regs.jpg) ![roda_das_janelas](https://github.com/gtLara/sparc/blob/master/images/Roda_das_janelas.jpg)
##### Dois registradores Program Counter 
A arquitetura SPARC prevê dois Program Counters: nPC e PC. PC guarda o endereço da instrução a ser executada no ciclo, enquanto nPC guarda o endereço da instrução seguinte.
##### Branch com comparação anterior e instrução atrasada
As intruções de Branch na arquitetura envolvem, para serem usadas, outras duas instruções. A primeira dessas é uma instrução que avalia a condição do branch `cmp`, antes da própria instrução de branch (`bl` por exemplo). A segunda é uma instrução que pode ou não ser executada, e fica logo depois da instrução de branch. Isso é possível porque o branch altera nPC, e não PC.
##### Demais características
Diversas características da arquitetura SPARC não foram citadas por não serem relevantes em nossa aplicação. Entre elas: Coprocessador, Unidade de Ponto Flutuante, Registradores de Estado, Traps, mudança de contexto usando as janelas de registradores, espaço para registradores extras, etc.
## Decisões de projeto
De maneira geral, as decisões de projeto foram tomadas tendo em vista a construção do mínimo de componentes necessário para a execução do algoritmo. As principais decisões estão listadas a seguir:
1. Como usaremos uma quantidade muito pequena de registradores e não precisaremos de mudar de contexto em momento algum, reduzimos o banco de registradores para 32 registradores, havendo só uma janela. São 8 globais (%g0 ~ %g7) e 24 de uso geral em três blocos de 8 (%o0 ~%o7, %l0 ~ %l7, %i0 ~ %i7).
2. Nosso processador é ciclo único e, por isso, adaptamos o Program Counter e a instrução de branch. Sem a presença de um pipeline não é preciso aguardar o branch ser calculado e executar outra instrução enquanto isso. O registrador nPC foi retirado, ficando apenas PC, e o branch passou a modificar diretamente PC, diferentemente de antes, que modificava nPC.
3. Usamos apenas um registrador de estado, o Processor State Register, e dele aproveitamos apenas um bit. O bit aproveitado (N) indica se o resultado da última operação da ALU foi negativo e é usado para decidir se o branch será tomado ou não.
4. O manual dava liberdade de implementar tanto uma memória única para dados e instruções quanto usar duas memórias separadas. Optamos por separar a memória de dados da memória de instruções.
5. O conjunto de operações da ALU foi reduzido para atender às nossas necessidades.   
## Implementação do processador
## Resultados e simulações
