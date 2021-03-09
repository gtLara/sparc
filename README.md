# Documentação
## Introdução: arquitetura SPARC e o trabalho desenvolvido
A arquitetura SPARC(Scalable Processor ARChitecture) surgiu em 1987, desenvolvida pela SUN Microsystems. Essa arquitetura se tornou muito popular e até hoje é amplamente utilizada. A arquitetura é aberta e pode ser implementada por qualquer um. Neste trabalho usaremos a versão 8 da SPARC, de 32 bits como inspiração. Devemos fazer um processador que execute um algoritmo simples de teste de paridade de bits.\
Características da arquitetura mais relevantes para nossa aplicação:
##### Banco de registradores de tamanho variável
São 8 registradores globais + N janelas de 16 registradores sobrepostas. Uma implementação pode ter de 40 registradores (duas janelas) até 520 registradores (32 janelas). Como há sobreposição de registradores, mostrado nas figuras `X` e `Y`, o número de unidades no hardware é menor. Mais informações sobre as imagens no documento referenciado.\
![sobreposicao_regs](https://github.com/gtLara/sparc/blob/master/images/sobreposi%C3%A7%C3%A3o_regs.jpg) ![roda_das_janelas](https://github.com/gtLara/sparc/blob/master/images/Roda_das_janelas.jpg)
##### Dois registradores Program Counter 
A arquitetura SPARC prevê dois Program Counters: nPC e PC. PC guarda o endereço da instrução a ser executada no ciclo, enquanto nPC guarda o endereço da instrução seguinte.
##### Branch com comparação anterior e intrução atrasada
As intruções de Branch na arquitetura envolvem, para serem usadas, outras duas instruções. A primeira dessas é uma instrução que avalia a condição do branch `cmp`, antes da própria instrução de branch (`bl` por exemplo). A segunda é uma instrução que pode ou não ser executada, e fica logo depois da instrução de branch. Isso é possível porque o branch altera nPC, e não PC.
##### Demais características
Diversas características da arquitetura SPARC não foram citadas por não serem relevantes em nossa aplicação. Entre elas: Coprocessador, Unidade de Ponto Flutuante, Registradores de Estado, Traps, mudança de contexto usando as janelas de registradores, etc.
## Decisões de projeto
## Implementação do processador
## Resultados e simulações
