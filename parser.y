%{
#include <iostream>
#include <cstdio>
#include <math.h>
#include <stdio.h>  
#include <string.h>
#include <map>
#include <vector>

int yylex(); 
int yyparse();
extern "C" FILE *yyin;
extern int line_num;
int yyerror(const char *p) { std::cerr << "error: " << " line num " << line_num << " " << p << std::endl; };

std::map<std::string,int> variables;
std::vector<int> check_line;

void tell_me_value(char* txt){  
	std::string temp(txt);
	
	std::cout << "the value of variable " << temp << ": is " << variables[temp] << std::endl;
	std::cout << "container size " << variables.size() << std::endl;
}

void print_line(){
	std::cout << "this is line number:  " << line_num << " " << std::endl;
	std::cout << "this is line in vector:  " << check_line.back() << " " << std::endl;
}

void declare_variable(char *txt){
	std::string temp(txt);
	
	if(variables.find(temp) == variables.end()){
			variables.insert(std::pair<std::string,int>(temp,0));
			check_line.push_back(line_num);
			return;  }
		
		else{
			std::cout << "multiple declarations of 1 var" << std::endl;
			return;  }  }
	/*
	if(variables.find(temp) == variables.end()){
		variables.insert(std::pair<std::string,int>(temp,0));
		return;
	}
	else{
		std::cout << "multiple declarations of variable" << std::endl;
		return;
	}*/


int is_var_there(char* txt){
	std::string temp(txt);
	if ( variables.find(temp) == variables.end()){
		//variables.insert(std::pair<std::string,int>(temp,0));
		return 0;
	}
	
	return 1;
}

int find_value(char* txt){
	std::string temp(txt);
	if ( variables.find(temp) == variables.end()){
		yyerror("variable undeclared");
		return 0;
	}
	check_line.push_back(line_num);
	return (variables[temp]);
}

void update_value(char* txt, int value){  
	std::string temp(txt);
	
	if (line_num != check_line.back()){
		variables[temp] = value;
		check_line.push_back(line_num); }
	else {
		std::cout << "2 many statements on 1 line" << std::endl;}
}

%}

%union {
    int val;
    char *sval;
};


%start prog

%token INT 
%token PRINT
%token EOL THEEND
%token LPAREN RPAREN 
%token PLUS MINUS MUL DIV
%token EQUAL

%token <val> NUM    
%token <sval> VAR

%type <val> expr
%type <sval> declaration
%type <val> assign


/* Resolve the ambiguity of the grammar by defining precedence. */

/* Order of directives will determine the precedence. */
%left PLUS MINUS    /* left means left-associativity. */
%left DIV MUL

%%

prog : 
	  line
	 | prog line
     ;

line : expr                 		     
	| declaration EOL                        
	| assign EOL							 
	| EOL
	| THEEND							{ exit(1); }
	;
	
expr : expr PLUS expr                   { $$ = $1 + $3; }
     | expr MINUS expr                  { $$ = $1 - $3; }
     | expr MUL expr                    { $$ = $1 * $3; }
     | expr DIV expr                    { $$ = $1 / $3; }
     | NUM                              { $$ = $1; } 
	 | VAR								{ if(!is_var_there($1)) yyerror("undefined var"); else $$ = find_value($1); }
	 | PRINT VAR						{ if(!is_var_there($2)) yyerror("var not there"); else std::cout << $2 << " is " << find_value($2) << std::endl; } 
     | LPAREN expr RPAREN               { $$ = $2; }
     ;

declaration : INT VAR					{  declare_variable($2); }

assign :  VAR EQUAL expr  		    	{  if(!is_var_there($1)) yyerror("not declared var"); else update_value($1, $3); }
	 

%%

int main(int argc, char *argv[])
{	
	++argv; 
	--argc;
	if(argc == 0){
		yyin = stdin;
		yyparse();
	} 
	else
		while(argc-- >0){
			yyin = fopen(argv[0], "r");
			if(!yyin){
				std::cout << "Cannot open" << std::endl;
				return 1;
			}
			yyparse();
			++argv;
		}
		return 0;
	
	
}
