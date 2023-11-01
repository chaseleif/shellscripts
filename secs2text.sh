#! /usr/bin/env bash

str="$1"
valstr=(second minute hour day)
vals=($((str%60)))  # secs
str=$((str/60))
vals+=($((str%60))) # mins
str=$((str/60))
vals+=($((str%24))) # hours
vals+=($((str/24))) # days
str=""
for i in $(seq 3 -1 0) ; do
  { [ "$i" -ne 0 ] || [ -n "$str" ]; } && [ "${vals[$i]}" -eq 0 ] && continue
  [ -n "$str" ] && str="${str}, "
  str="${str}${vals[$i]} ${valstr[$i]}"
  [ "${vals[$i]}" -ne 1 ] && str="${str}s"
done
echo "$str"

