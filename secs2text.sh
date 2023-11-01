#! /usr/bin/env bash

timestr="$1"
valstr=(second minute hour day)
vals=($((timestr%60)))  # secs
timestr=$((timestr/60))
vals+=($((timestr%60))) # mins
timestr=$((timestr/60))
vals+=($((timestr%24))) # hours
vals+=($((timestr/24))) # days
timestr=""
comma() { [ -n "$timestr" ] && timestr="${timestr}, " ; }
plural() { [ "$1" -ne 1 ] && timestr="${timestr}s" ; }
for i in $(seq 3 -1 1) ; do
  [ "${vals[$i]}" -eq 0 ] && continue
  comma
  timestr="${timestr}${vals[$i]} ${valstr[$i]}"
  plural "${vals[$i]}"
done
if [[ -z "$timestr" || "${vals[0]}" -gt 0 ]] ; then
  comma
  timestr="${timestr}${vals[0]} second"
  plural "${vals[0]}"
fi
echo "$timestr"

