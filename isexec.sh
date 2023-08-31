#! /usr/bin/env bash

### If arg0 is set and is executable . . .

if [ ! -z $1  ] && [ -x $1 ]; then
  echo "$1 is executable"
else
  echo "$1 is not executable"
fi
