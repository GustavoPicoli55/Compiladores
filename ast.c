/*
        Etapa 3 - Compiladores (2024/1) - Lucas M. Schnorr
		Grupo S: Gustavo Picoli - 00332780 e Nathan Mattes - 00342941
*/

#include "ast.h"


ast *ast_new(const char *label){
	ast *r = (ast*)malloc(sizeof(ast));
	if(r != NULL){
		r->label = strdup(label);
		r->number_of_children = 0;
		r->children = NULL;
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
	free(root);
}


void ast_add_child(ast *root, ast *child){
	if(root == NULL){
		printf("ERROR: ast_add_child(null, )\n");
		return;
	}
	if(child == NULL){
		printf("ERROR: ast_add_child( , null)\n");
		return;
	}
	root->number_of_children++;
	root->children = realloc(root->children, root->number_of_children * sizeof(ast*));
	root->children[root->number_of_children-1] = child;
}


void ast_pop_child(ast *root){
	if(root == NULL){
		printf("ERROR: ast_pop_child(null, )\n");
		return;
	}
	root->number_of_children--;
	root->children = realloc(root->children, root->number_of_children * sizeof(ast*));
}

void exporta(ast *root)
{
  int i;
  if (root != NULL) {
    printf("%p [label=\"%s\"];\n", root, root->label);

    for (i = 0; i < root->number_of_children; i++) {
      printf("%p, %p\n", root, root->children[i]);
    }

    for (i = 0; i < root->number_of_children; i++) {
      exporta(root->children[i]);
    }
  }
}