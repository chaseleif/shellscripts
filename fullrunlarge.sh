#! /usr/bin/env bash

## This script runs another script 5 times, each time passing an argument
## This script executes the other script passing the arguments (1-5)

for i in $(seq 1 5)
do
  ./runlarge.sh $i
done

