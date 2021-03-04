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
    crc ^= ((dados >> i) & 0x01);
  }
  return crc;
}
