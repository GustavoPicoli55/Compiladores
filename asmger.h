/*
        Etapa 6 - Compiladores (2024/1) - Lucas M. Schnorr
		Grupo S: Gustavo Picoli - 00332780 e Nathan Mattes - 00342941
*/

#ifndef _ASMGER_H
#define _ASMGER_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "simbol.h"

/*
 * Função cria_cod_seg, imprime segmento de codigo em assembly.
 */
void cria_cod_seg(listOpIloc *codigo);

/*
 * Função cria_dado_seg, imprime segmento de dados em assembly.
 */
void cria_dado_seg(simbolTable *dados);

/*
 * Função exporta, exporta o codigo criado em assemblt.
 */
void exporta(listOpIloc *codigo, simbolTable *dados);

#endif //_ASMGER_H