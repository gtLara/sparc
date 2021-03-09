# Documentação
## Introdução: arquitetura SPARC e o trabalho desenvolvido
A arquitetura SPARC(Scalable Processor ARChitecture) surgiu em 1987, desenvolvida pela SUN Microsystems. Essa arquitetura se tornou muito popular e até hoje é amplamente utilizada. A arquitetura é aberta e pode ser implementada por qualquer um. Neste trabalho usaremos a versão 8 da SPARC, de 32 bits.\
Principais características da arquitetura:
##### Banco de registradores de tamanho variável
São 8 registradores globais + N janelas de 16 registradores sobrepostas. Uma implementação pode ter de 40 registradores (duas janelas) até 520 registradores (32 janelas). Como há sobreposição de registradores, mostrado nas figuras `X` e `Y`, o número de unidades no hardware é menor. Mais informações sobre as imagens no documento referenciado.\
![sobreposicao_regs](https://github.com/gtLara/sparc/blob/master/images/sobreposi%C3%A7%C3%A3o_regs.jpg) ![roda_das_janelas](https://github.com/gtLara/sparc/blob/master/images/Roda_das_janelas.jpg)
##### Dois registradores Program Counter 

## Decisões de projeto
## Implementação do processador
## Resultados e simulações
