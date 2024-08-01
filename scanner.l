%{
	/*
        Etapa 1 - Compiladores (2024/1) - Lucas M. Schnorr
		Grupo S: Gustavo Picoli - 00332780 e Nathan Mattes - 00342941
	*/
	#include "parser.tab.h"
%}

%option noyywrap
%option yylineno
%x comment

%%

 /*Reconhecimento de literais*/
"false"					{return TK_LIT_FALSE;  	}   
"true" 					{return TK_LIT_TRUE;    }
[0-9]+					{return TK_LIT_INT;     }
[0-9]*"."[0-9]+			{return TK_LIT_FLOAT;   }

 /*Reconhecimento de palavrass reservadas*/
"int"                   {return TK_PR_INT;		}       
"float"                 {return TK_PR_FLOAT;	}     
"bool"					{return TK_PR_BOOL;		}	 
"if"                    {return TK_PR_IF;		}        
"else"                  {return TK_PR_ELSE;		}      
"while"                 {return TK_PR_WHILE;	}     
"return"                {return TK_PR_RETURN;	}

 /*Reconhecimento de caracteres especias*/
"-" 					{return *yytext;		}
"!" 					{return *yytext;		}
"*" 					{return *yytext;		}
"/" 					{return *yytext;		}
"%" 					{return *yytext;		}
"+" 					{return *yytext;		}
"<" 					{return *yytext;		}
">" 					{return *yytext;		}
"{"						{return *yytext;		}
"}" 					{return *yytext;		}
"(" 					{return *yytext;		}
")" 					{return *yytext;		}
"=" 					{return *yytext;		}
"," 					{return *yytext;		}
";" 					{return *yytext;		}  

 /*Reconhecimento de operadores logicos*/
"<="                    {return TK_OC_LE;		}  
">="                    {return TK_OC_GE;  		}
"=="                    {return TK_OC_EQ;  		}	
"!="                    {return TK_OC_NE;  		}
"&"						{return TK_OC_AND; 		}
"|"						{return TK_OC_OR;  		}

 /*Reconhecimento de identificadores*/
[a-z_][a-z0-9_]*  		{return TK_IDENTIFICADOR; 	}

 /*Ignorar "nao-caracteres"*/
[ \t]+ {}
[ \r]+ {}
\/\/(.)* {}

 /*Reconhecimento de inicio de comentario multi-line*/
"/*"    BEGIN(comment);

 /*Ignorar nova linha*/
\n {}

 /*Reconnhece erro*/
.						{return TK_ERRO;		}

 /*Tratamento dos comentarios multi-line*/
<comment>[^*\n]*       
<comment>"*"+[^*/\n]*  
<comment>\n yylineno;
<comment>"*"+"/"        BEGIN(INITIAL);

%%

//Funcao que retorna numero atual de linhas
int get_line_number(void){
	return yylineno;
}