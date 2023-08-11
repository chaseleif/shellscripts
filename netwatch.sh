#! /usr/bin/env bash

start=$(date "+%s")
date

url="ifconfig.me"

echo -n "waiting for network "
i=0
while true ; do
  i=$((i+1))
  if [ $i -eq 15 ] ; then
    i=-10
    stdbuf -o0 echo "."
  else
    stdbuf -o0 echo -n ". "
  fi
  addr=$(curl --no-fail --connect-timeout 20 "$url" 2> /dev/null)
  if [ "$addr" != "" ] ; then
    echo "
$addr"
    break
  fi
  sleep 1
done

total=$(($(date "+%s")-start))
date
secs=$((total%60))
total=$((total/60))
mins=$((total%60))
hours=$((total/60))
days=$((hours/24))
if [ $days -gt 0 ] ; then
  hours=$((hours%24))
fi
echo -n "Elapsed time: "
docomma=0
if [ $days -gt 0 ] ; then
  echo -n "$days day"
  if [ $days -ne 1 ] ; then echo -n "s" ; fi
  docomma=1
fi
if [ $hours -gt 0 ] ; then
  if [ $docomma -ne 0 ] ; then echo -n ", " ; else docomma=1 ; fi
  echo -n "$hours hour"
  if [ $hours -ne 1 ] ; then echo -n "s" ; fi
fi
if [ $mins -gt 0 ] ; then
  if [ $docomma -ne 0 ] ; then echo -n ", " ; else docomma=1 ; fi
  echo -n "$mins minute"
  if [ $mins -ne 1 ] ; then echo -n "s" ; fi
fi
if [[ $docomma -eq 0 || $secs -gt 0 ]] ; then
  if [ $docomma -ne 0 ] ; then echo -n ", " ; fi
  echo -n "$secs second"
  if [ $secs -ne 1 ] ; then echo -n "s" ; fi
fi
echo ""
