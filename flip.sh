#! /usr/bin/env bash

if [ $(($(printf '%d' "0x$(head -c1 /dev/urandom |xxd -p)")&1)) -eq 0 ] ; then
  echo "heads"
else
  echo "tails"
fi
