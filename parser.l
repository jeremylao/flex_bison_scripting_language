%{
#include <iostream>
#include <stdlib.h>
#include "parser.tab.h"  
#include <vector>
#include <stdio.h>   
#include <string.h>
int line_num = 1;
%}


%option noyywrap
%x IN_COMMENT
%x IN_COMMENT_LONG

%%

<INITIAL>{
	\/\/														{ BEGIN(IN_COMMENT); }
	\/\*														{ BEGIN(IN_COMMENT_LONG); }
	[0-9]+    	     											{ yylval.val = atoi(yytext); return NUM; }
	[iI][nN][tT]												{ return INT; }
	[pP][rR][iI][nN][tT]										{ return PRINT; }
	[a-zA-Z][a-zA-Z0-9]{15,}									{ std::cerr << "Invalid variable, too long" << std::endl; exit(1); }
	[0-9][a-zA-Z0-9]{0,14}										{ std::cerr << "Invalid variable cannot start with number" << std::endl; exit(1); }
	[a-zA-Z][a-zA-Z0-9]{0,14}									{ yylval.sval=strdup(yytext); return VAR; }
	"="															{ return EQUAL; }
	"+"                     									{ return PLUS; }
	"-"                     									{ return MINUS; }
	"*"                     									{ return MUL; }
	"/"                     									{ return DIV; }
	"("                     									{ return LPAREN; }
	")"                     									{ return RPAREN; }
	[ \t]+      	        									{ /* Ignore white characters. */ }
	[ \n]														{ ++line_num; return EOL; }
	[\r]														{ return EOL; }
	<<EOF>>														{ return THEEND; }
	\*\/														{ std::cerr << "Unclosed Comment" << std::endl; exit(1); }
	.                       									{ std::cerr << "Invalid token" << std::endl; exit(1); }
}

<IN_COMMENT>.												;
<IN_COMMENT>[\n]											{ BEGIN(INITIAL); }

<IN_COMMENT_LONG>{

	[ \t\r\n]+ 					{ /* Ignore white characters. */ }
	. 							;
	\*\/						{ BEGIN(INITIAL); }
	<<EOF>>						{ std::cerr << "Unclosed COmment" << std::endl; exit(1); }
}
%%
