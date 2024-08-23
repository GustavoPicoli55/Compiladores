/*
        Etapa 6 - Compiladores (2024/1) - Lucas M. Schnorr
		Grupo S: Gustavo Picoli - 00332780 e Nathan Mattes - 00342941
*/

#include "ast.h"

ast *ast_new(const char *label, const char *type){
	ast *r = (ast*)malloc(sizeof(ast));
	if(r != NULL){
		r->label = strdup(label);
		r->type = strdup(type);
		r->number_of_children = 0;
		r->children = NULL;
		r->temp = NULL;
		r->code = NULL;
	}
	r->is_scoped_block = false;
	return r;
}


void ast_free(ast *root){
	if(root == NULL){
		return;
	}
	for(int i = 0; i < root->number_of_children; i++){
		ast_free(root->children[i]);
	}
	free(root->children);
	free(root->label);
	free(root->type);
	free(root->temp);
	free(root->code);
	free(root);
}


void ast_add_child(ast *root, ast *child){
	if(root == NULL){
		return;
	}
	if(child == NULL){
		return;
	}
	root->number_of_children++;
	root->children = realloc(root->children, root->number_of_children * sizeof(ast*));
	root->children[root->number_of_children-1] = child;
}


void ast_pop_child(ast *root){
	if(root == NULL){
		return;
	}
	root->number_of_children--;
	root->children = realloc(root->children, root->number_of_children * sizeof(ast*));
}