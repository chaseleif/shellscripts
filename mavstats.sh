#! /bin/bash

## driver for genstats.sh for caliper output files from maverick
## The outputs from cali-query are printed to stdout
## These outputs are piped to the condense.py script
## The output of the condense.py script is written to file

./genstats.sh maverick/ap/withfile/ap_10x1000_d220_p16/snapshots/ | python condense.py > maverick/ap/withfile/ap_10x1000_d220_p16/calistat
./genstats.sh maverick/ap/withfile/ap_10x1000_d220_p4/snapshots/ | python condense.py > maverick/ap/withfile/ap_10x1000_d220_p4/calistat
./genstats.sh maverick/ap/withfile/ap8b_10x1000_d440_p4/snapshots/ | python condense.py > maverick/ap/withfile/ap8b_10x1000_d440_p4/calistat
./genstats.sh maverick/ap/withfile/ap8b_10x1000_d220_p16/snapshots/ | python condense.py > maverick/ap/withfile/ap8b_10x1000_d220_p16/calistat
./genstats.sh maverick/ap/withfile/ap8b_10x1000_d440_p16/snapshots/ | python condense.py > maverick/ap/withfile/ap8b_10x1000_d440_p16/calistat
./genstats.sh maverick/ap/withfile/ap_10x1000_d440_p4/snapshots/ | python condense.py > maverick/ap/withfile/ap_10x1000_d440_p4/calistat
./genstats.sh maverick/ap/withfile/ap_10x1000_d440_p16/snapshots/ | python condense.py > maverick/ap/withfile/ap_10x1000_d440_p16/calistat
./genstats.sh maverick/gh/withfile/gh_10x1000_d440_p4/snapshots/ | python condense.py > maverick/gh/withfile/gh_10x1000_d440_p4/calistat
./genstats.sh maverick/gh/withfile/gh_10x1000_d220_p4/snapshots/ | python condense.py > maverick/gh/withfile/gh_10x1000_d220_p4/calistat
./genstats.sh maverick/gh/withfile/gh_10x1000_d220_p16/snapshots/ | python condense.py > maverick/gh/withfile/gh_10x1000_d220_p16/calistat
./genstats.sh maverick/gh/withfile/gh_10x1000_d440_p16/snapshots/ | python condense.py > maverick/gh/withfile/gh_10x1000_d440_p16/calistat
