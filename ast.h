/*
        Etapa 4 - Compiladores (2024/1) - Lucas M. Schnorr
		Grupo S: Gustavo Picoli - 00332780 e Nathan Mattes - 00342941
*/

#ifndef _AST_H
#define _AST_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

struct _vl{
		int t_line;
		char* t_type;
		char* t_value;
} typedef vl;

struct _ast{
	char *label;
	char *type;
	int number_of_children;
	bool is_scoped_block;
	struct _ast **children;
} typedef ast;

/*
 * Função ast_new, cria um no sem filhos com o label informado.
 */
ast *ast_new(const char *label, const char *type);

/*
 * Função ast_free, libera recursivamente o no e seus filhos.
 */
void ast_free(ast *root);

/*
 * Função ast_add_child, adiciona child como filho de tree.
 */
void ast_add_child(ast *root, ast *child);

/*
 * Função ast_pop_child, remove child de tree.
 */
void ast_pop_child(ast* root);

/*
 * Função print_tree, imprime tree na tela.
 */
void print_tree(ast *root);

/*
 * Função exporta, permite uso da arvore final por programas externos.
 */
void exporta(ast *root);


#endif // _AST_H