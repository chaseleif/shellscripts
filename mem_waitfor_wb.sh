#! /usr/bin/env bash

## This script will print the memory that is waiting
##  to get written back to disk
## This script can be ran as: `watch ./mem_waitfor_wb.sh`

cat /proc/meminfo | grep Dirty
