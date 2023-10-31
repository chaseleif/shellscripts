#! /usr/bin/env bash

total="$1"
secs=$((total%60))
total=$((total/60))
mins=$((total%60))
hours=$((total/60))
days=$((hours/24))
if [ $days -gt 0 ] ; then
  hours=$((hours%24))
fi
docomma=0
if [ $days -gt 0 ] ; then
  echo -n "$days day"
  if [ $days -ne 1 ] ; then echo -n "s" ; fi
  docomma=1
fi
if [ $hours -gt 0 ] ; then
  if [ $docomma -ne 0 ] ; then echo -n ", " ; else docomma=1 ; fi
  echo -n "$hours hour"
  if [ $hours -ne 1 ] ; then echo -n "s" ; fi
fi
if [ $mins -gt 0 ] ; then
  if [ $docomma -ne 0 ] ; then echo -n ", " ; else docomma=1 ; fi
  echo -n "$mins minute"
  if [ $mins -ne 1 ] ; then echo -n "s" ; fi
fi
if [[ $docomma -eq 0 || $secs -gt 0 ]] ; then
  if [ $docomma -ne 0 ] ; then echo -n ", " ; fi
  echo -n "$secs second"
  if [ $secs -ne 1 ] ; then echo -n "s" ; fi
fi
echo ""
