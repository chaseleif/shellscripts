#! /usr/bin/env bash

domains=(8.8.8.8
          4.2.2.2
          8.8.4.4
          4.1.1.1)

try() {
  ping -c1 -q "$1" >/dev/null 2>&1 && return 0 || return 1
}

total=0
domaini=-1
while true ; do
  domaini=$((domaini+1))
  if [ "$domaini" -eq "${#domains[@]}" ] ; then
    domaini=0
  fi
  sleep $(shuf -i 40-90 --random-source=/dev/urandom -n1)
  try "${domains[$domaini]}" && continue
  domaini=$((domaini+1))
  if [ "$domaini" -eq "${#domains[@]}" ] ; then
    domaini=0
  fi
  sleep $(shuf -i 30-60 --random-source=/dev/urandom -n1)
  try "${domains[$domaini]}" && continue
  date
  echo " ~ Outage start ~"
  out=$(date "+%s")
  ./netwatch.sh >/dev/null 2>&1
  out=$(($(date "+%s")-out))
  total=$((total+out))
  echo "Outage of $out seconds"
  echo "Total outage time $total"
  date
done

