#! /usr/bin/env bash

secs2ts() {
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
}

lastbreak=0
printtime() {
  total=$(date "+%s")
  if [ $((total-lastbreak)) -lt 10 ] ; then
    printf "Aborted\n"
    exit
  fi
  if [ "$lastbreak" -gt 0 ] ; then
    printf '\e[A\e[K'
  else
    printf "\n"
  fi
  lastbreak="$total"
  total=$((total-start))
  secs2ts
}
stty -echoctl
trap 'printtime' SIGINT

start=$(date "+%s")

url="ifconfig.me"

echo "###
# Press ctrl-c to print the current elapsed time
# Press ctrl-c twice within 10 seconds to quit
###
"

date
printf "\nWaiting for network . . ."
while true ; do
  addr=$(curl --no-fail --connect-timeout 20 "$url" 2> /dev/null)
  if [ "$addr" != "" ] ; then
    echo " $addr"
    break
  fi
  sleep 1
done

total=$(($(date "+%s")-start))
printf "Network up !\n\nTotal ~ "
secs2ts
printf "\n"
date
