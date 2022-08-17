#! /usr/bin/env bash

# This is a driver/test script for my kmeans program

# The kmeans program is the first argument
# The k value is the second argument
# This iterates through all "input*.txt" files
# Numbers the output/centroid files based on the input file number
# With "input1.txt"
# "output.txt" -> "output1.txt"
# "centroids.txt" -> "centroids1.txt"

if [ -z $1 ] ; then
  echo "Usage:"
  echo "$0 ./kmeans [k]"
  echo "The program must be specified"
  echo "The k is optional"
  echo "If the k is not present it will be derived from the input filename"
  exit
fi

for filename in $(ls) ; do
  if [[ ${filename} != input* ]] ; then
    continue
  fi
  outnum=$(echo ${filename#*"input"*} | cut -f 1 -d '.')
  if [ -z $2 ] ; then
    # This handles the k= from the input filename
    # input1 and input2 will get k=2 . . . (2 is the minimum k)
    # input3 will get k=3
    # input4 will get k=4, etc.
    # This makes the k match what is shown in a2datasets.txt
    ./$1 $outnum $filename
  else
    ./$1 $2 $filename
  fi
  mv -f output.txt output${outnum}.txt
  mv -f centroids.txt centroids${outnum}.txt
done
