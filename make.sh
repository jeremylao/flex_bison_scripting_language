#!/bin/sh

if [ ! -f parser.y -o ! -f parser.l ] ; then
  echo No target.
  exit
fi

bison -d parser.y
flex parser.l
g++ lex.yy.c parser.tab.c

#rm lex.yy.c $1.tab.h $1.tab.c


