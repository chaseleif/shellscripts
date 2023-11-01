#! /usr/bin/env bash

total="$1"
secs=$((total%60))
total=$((total/60))
mins=$((total%60))
hours=$((total/60))
days=$((hours/24))
if [ $days -gt 0 ] ; then
  hours=$((hours%24))
  str="$days day"
  if [ $days -ne 1 ] ; then str="${str}s" ; fi
fi
if [ $hours -gt 0 ] ; then
  if [ -n "$str" ] ; then str="${str}, " ; fi
  str="${str}${hours} hour"
  if [ $hours -ne 1 ] ; then str="${str}s" ; fi
fi
if [ $mins -gt 0 ] ; then
  if [ -n "$str" ] ; then str="${str}, " ; fi
  str="${str}${mins} minute"
  if [ $mins -ne 1 ] ; then str="${str}s" ; fi
fi
if [[ -z "$str" || $secs -gt 0 ]] ; then
  if [ -n "$str" ] ; then str="${str}, " ; fi
  str="${str}${secs} second"
  if [ $secs -ne 1 ] ; then str="${str}s" ; fi
fi
echo "$str"
