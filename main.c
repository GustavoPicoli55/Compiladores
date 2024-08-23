#include <stdio.h>
extern int yyparse(void);
extern int yylex_destroy(void);
int main (int argc, char **argv)
{
  int ret = yyparse(); 
  yylex_destroy();
  return ret;
}