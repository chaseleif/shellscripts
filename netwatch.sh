#! /usr/bin/env bash

lastbreak=0
printtime() {
  total=$(date "+%s")
  if [ $((total-lastbreak)) -lt 10 ] ; then
    printf "Aborted\n"
    exit
  fi
  if [ "$lastbreak" -gt 0 ] ; then
    printf '\e[A\e[K'
  fi
  lastbreak="$total"
  total=$((total-start))
  echo "Elapsed time: $(./secs2text.sh $total)"
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
printf "\nWaiting for network . . .\n"
while true ; do
  addr=$(curl --no-fail --connect-timeout 20 "$url" 2> /dev/null)
  if [ "$addr" != "" ] ; then
    printf "\n%s ~ " "$addr"
    break
  fi
  sleep 1
done

total=$(($(date "+%s")-start))

if [ "$lastbreak" -gt 0 ] ; then
  printf '\e[A\e[K'
fi

printf "Network up !\n\nTotal elapsed time: "
./secs2text.sh "$total"
date

