! Instruções a serem usadas:
! ld - pra iniciar variáveis
! jmpl, com reg destino %g0 - pro for (salto incondicional)
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
    dados:  .word 0x04    !dado de 8bits a ser analisado 
    crc:    .word 1    !se dados = 0, crc = 1 e paridade par
    
.section ".text"

main:   ld crc , %l0        ! traz os dados da memória de dados
        ld dados , %l1      ! para os registradores locais
        
        add %g0, %g0, %l7   ! inicia %l7 = i = 0        

for:    and %l1, 0x001, %l2     ! pega o LSB do dados atual e poe em %l2
        xor %l0, %l2, %l0   ! atualiza o crc com o bit de dados
        srl %l1, 1, %l1     ! dados >>= 1 

        add %l7, 1, %l7     ! incrementa i
        cmp %l7 , 8         ! compara i com 8 e modifica o icc
        bl,a for            ! se i < 8 volta pro for, sem a instrução de delay
!FIM, o resultado com crc fica em %l0
        
        printf("%d",crc);
