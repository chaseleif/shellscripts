#! /bin/bash

## This script will delete the trailing period to EOL
## this removes a file extension from a string

echo $0

filename=$(echo $1 | cut -f 1 -d '.')

if [ "$filename" == "-h" ] || [ "$filename" == "--help" ] ; then
  echo "Put in an argument, we'll delete the file extension"
fi
if [ -z "$filename" ] ; then
  echo "Enter a filename . . ."
else
  echo $filename
fi
