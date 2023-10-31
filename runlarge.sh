#! /usr/bin/env bash

## This script executes a program with a numeric argument
## stdout of the program is fed into a loop
## This output is piped to sort, then is appended to a file

INPUT=./boards.db
HFUN=$1
IFS=\n

[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 0; }


echo =============================
echo "start - heuristic number $HFUN: $(date +%Y-%m-%d-%H:%M:%S)" >> testtime$HFUN
echo "start - heuristic number $HFUN: $(date +%Y-%m-%d-%H:%M:%S)";
while read line
  do
    ./astar h$HFUN "$line" testing
done < $INPUT | sort -n -r -k 1,1 >> testtime$HFUN

echo "end - heuristic number $HFUN: $(date +%Y-%m-%d-%H:%M:%S)" >> testtime$HFUN

