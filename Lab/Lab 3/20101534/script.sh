#!/bin/bash

yacc -d -y --debug --verbose 20101534.y
echo 'Generated the parser C file as well the header file'
g++ -w -c -o y.o y.tab.c
echo 'Generated the parser object file'
flex 20101534.l
echo 'Generated the scanner C file'
g++ -fpermissive -w -c -o l.o lex.yy.c
echo 'Generated the scanner object file'
g++ y.o l.o
echo '.exe file generated'
echo 'Removing the unnecessery generated files'
rm y.o l.o lex.yy.c y.tab.c y.tab.h y.output
echo 'All ready, running a.exe with <yourinput>.txt file'
./a.exe input.txt
echo 'Output file saved into 20101534_log.txt'

