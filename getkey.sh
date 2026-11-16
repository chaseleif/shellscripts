#! /usr/bin/env bash

key="Press ctrl-c to quit . . ."

printf "This script will print the keys you press\n"
printf "%s\n" "$key"

while true ; do
  if IFS= read -r -s -n1 -t 0.2 key ; then
    printf "$'\e'"
    IFS= read -r -s -n2 -t0.05 key
    printf "%s\n" "$key"
  elif [ -n "$key" ] ; then
    printf "%s\n" "$key"
  fi
done
