#! /usr/bin/env bash

set -e

for bits in $(seq 1024 1024 8192) ; do
  modulifile="moduli-${bits}"
  [ -f "$modulifile" ] && continue
  candidates="${modulifile}.candidates"
  chkptfile="${modulifile}.chkpt"
  if [ ! -f "$candidates" ] ; then
    ssh-keygen -M generate -O memory=127 -O bits="$bits" "$candidates"
  fi
  ssh-keygen -M screen -f "$candidates" -O checkpoint="$chkptfile" "$modulifile"
  rm -f "$candidates" "$chkptfile"
done
