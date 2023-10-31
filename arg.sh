#! /usr/bin/env bash

# This tests if the first argument passed was "-a"

DOALL=0

if [[ "$1" == "-a" ]]
then
  echo "\$1 == -a"
  DOALL=1
else
  echo "\$1 == -a returned false"
fi
if [[ "$DOALL" == 1 ]]
then
  echo "DOALL was set to 1"
else
  echo "DOALL is zero"
fi
