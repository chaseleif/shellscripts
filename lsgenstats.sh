#! /bin/bash

## This script runs cali-query for all cali log files

###
# Running with no arguments will search for all *.cali files in this directory
# Run with argument to specify a file prefix for cali files
###

set -e

declare -a queries
declare -a labels

# lonestar
labels[0]="L2 Data Cache Misses"
queries[0]=--query="SELECT *, min(papi.PAPI_L2_TCM) as \"Min\", avg(papi.PAPI_L2_TCM) as \"Avg\", max(papi.PAPI_L2_TCM) as \"Max\", inclusive_percent_total(papi.PAPI_L2_TCM) AS \"L2 Data Cache Misses \%\" GROUP BY prop:nested FORMAT tree"
labels[1]="L2 Cache Hits"
queries[1]=--query="SELECT *, min(papi.PAPI_L2_TCH) as \"Min\", avg(papi.PAPI_L2_TCH) as \"Avg\", max(papi.PAPI_L2_TCH) as \"Max\", inclusive_percent_total(papi.PAPI_L2_TCH) AS \"L2 Cache Hits \%\" GROUP BY prop:nested FORMAT tree"
labels[2]="Inclusive time duration"
queries[2]=--query="SELECT *, min(time.inclusive.duration) as \"Min\", avg(time.inclusive.duration) as \"Avg\", max(time.inclusive.duration) as \"Max\", inclusive_percent_total(time.inclusive.duration) AS \"Inclusive time duration \%\" GROUP BY prop:nested FORMAT tree"

# maverick
#labels[0]="Inclusive time duration"
#queries[0]=--query="SELECT *, min(time.inclusive.duration) as \"Min\", avg(time.inclusive.duration) as \"Avg\", max(time.inclusive.duration) as \"Max\", inclusive_percent_total(time.inclusive.duration) AS \"Inclusive time duration \%\" GROUP BY prop:nested FORMAT tree"
#labels[1]="Cupti activity duration"
#queries[1]=--query="SELECT *, min(cupti.activity.duration) as \"Min\", avg(cupti.activity.duration) as \"Avg\", max(cupti.activity.duration) as \"Max\", inclusive_percent_total(cupti.activity.duration) AS \"Cupti activity duration \%\" GROUP BY function,cupti.runtimeAPI format tree"

for i in "${!queries[@]}"
do
  echo "##########"
  echo "## "${labels[i]}""
  echo "##########"
  if (( $# == 0 )); then
    for filename in *.cali; do
      [ -e "$filename" ] || continue
      ../../Caliper/install/bin/cali-query "${queries[i]}" "$filename"
    done
  else
    for filename in "$1"*; do
      [ -e "$filename" ] || continue
      ../../Caliper/install/bin/cali-query "${queries[i]}" "$filename"
    done
  fi
  echo "##########"
  echo "## Finished "${labels[i]}""
  echo "##########"
done
