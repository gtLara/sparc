! Instruções a serem usadas:
! ld - pra iniciar variáveis
! jmpl, com reg destino %g0 - pro for (salto incondicional)
! add - pro for
! cmp a,b = subcc a, b, %g0 - para mudar o icc e usar o bge
! bge,a - "Branch on Greater or Equal" com annul ",a" pro for
! srl
! xor
! and

! dilaceramos o banco de registradores, só usamos 32 + 1:
! %g0 ~ %g7 = %r0  ~ %r7   - registradores globais
! %o0 ~ %07 = %r8  ~ %r15  - registradores Out
! %l0 ~ %l7 = %r16 ~ %r23 - registradores locais
! %i0 ~ %i7 = %r24 ~ %r31 - registradores in
! %g0 = %r0 = constante 0
! %PSR - registrador de estado, usa ele no bge
! tem o PC tbm, mas ele sempre existe

!seções devem ser iniciadas assim:
.section ".data"

.section ".text"
