#! /usr/bin/env bash

domains=(8.8.8.8
          4.2.2.2
          8.8.4.4
          4.1.1.1)

try() {
  domaini=$((domaini+1))
  if [ "$domaini" -eq "${#domains[@]}" ] ; then
    domaini=0
  fi
  return 1
  ping -c1 -q "${domains[$domaini]}" >/dev/null 2>&1 && return 0 || return 1
}

echo "$$"

total=0
domaini=-1
while true ; do
  sleep "$(shuf -i 40-90 --random-source=/dev/urandom -n1)"
  try && continue
  sleep "$(shuf -i 30-60 --random-source=/dev/urandom -n1)"
  try && continue
  date
  echo " ~ Outage start ~"
  out=$(date "+%s")
  ./netwatch.sh >/dev/null 2>&1
  out=$(($(date "+%s")-out))
  total=$((total+out))
  echo "This outage: $(./secs2text.sh $out)"
  echo "Total outages: $(./secs2text.sh $total)"
  date
done

