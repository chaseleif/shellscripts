#! /usr/bin/bash

## This script replaces the first occurence in a text file
## "yy_size_t yyleng" -> "int yyleng"

awk '/yy_size_t yyleng/ && !ok { sub(/yy_size_t yyleng/,"int yyleng"); ok=1 } 1' src/scanner.l > newscanner.l && mv newscanner.l src/scanner.l
