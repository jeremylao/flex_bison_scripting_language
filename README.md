# flex_bison

Type 'make' to run the shell script (chmod +x make.sh, then 'make' if unable to make initially)

After successfully compiling, program command is ./a.out

This is a simple scripting language calculator.  

Variables are created 'int varname', must start with a letter but can be a combination of letters and numbers and no more than 16 charaters long

After creating a variable, integers are assigned [0-9]+ to the variables as example: 'varname = 9 + 8'

Legal operations are +,-,*,/

One line omments are denoted as // 

Multi line comments are  /*  */

Parens '(' and ')' can be used to denote precedence.  

'print varname' will print what is stored in the variable. (error if variable is not initialized, and 0 if only initialized)

Entering '.' will exit the program


Example:

int x
int y 
int z
x = 7
y = 8
z = x + y + 1
print z

Output: z is 16
