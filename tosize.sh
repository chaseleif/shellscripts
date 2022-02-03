#! /usr/bin/bash

## This script replaces the first occurence in a text file
## "int yyleng" -> "yy_size_t yyleng"

awk '/int yyleng/ && !ok { sub(/int yyleng/,"yy_size_t yyleng"); ok=1 } 1' src/scanner.l > newscanner.l && mv newscanner.l src/scanner.l

