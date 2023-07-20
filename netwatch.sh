#! /usr/bin/env bash

date

echo -n "waiting for network "
i=0
while [ 1 ] ; do
  i=$((i+1))
  if [ $i -eq 15 ] ; then
    i=-10
    echo "."
  else
    echo -n ". "
  fi
  addr=$(curl --no-fail --connect-timeout 20 "$addr" 2> /dev/null)
  if [ "$addr" != "" ] ; then
    echo "
$addr"
    break
  fi
  sleep 1
done

date
