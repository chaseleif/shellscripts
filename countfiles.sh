#! /usr/bin/env bash

pad() {
  [ "$#" -gt 1 ] && [ -n "$2" ] && printf "%$2.${2#-}s" "$1"
}

tput colors > /dev/null 2>&1
if [ $? -eq 0 ] ; then
  bold=$(tput bold)
  normal=$(tput sgr0)
fi

echo "______________________________"
ls progress/progress* > /dev/null 2>&1
if [ $? -ne 0 ] ; then
  echo "No progress files exist"
else
  if [ -f progress/lock ] ; then
    echo -n "$(pad "Running since:" -19)"
    timefile=progress/lock
  else
    echo -n "$(pad "Last stopped:" -19)"
    timefile=$(ls -t progress/progress* | head -n1)
  fi
  echo $(date -r $timefile +"%d %b %R")
  failedsubs=$(grep -R ^sub progress/progress* | wc -l)
  if [ $failedsubs -ne 0 ] ; then
    echo "$(pad "Failed retrievals:" -19)$failedsubs"
  fi
fi
if [ -f err.log ] ; then
  echo "$(pad "Errors logged:" -19)$(grep ^\# err.log | wc -l)"
  echo "$(pad "Last error:" -19)$(date -r err.log +"%d %b %R")"
fi
#sizes=($(du -c -d0 -h contest*/ 2> /dev/null))
sizes=($(du -c -d0 -BM contest*/ 2> /dev/null))
if [ $? -ne 0 ] ; then
  echo "No contest directories exist"
  echo "______________________________"
  exit
fi
totalfiles=0
echo "______________________________"
for num in $(ls -d contest* | cut -dt -f3 | sort --numeric) ; do
  if [ ! -d contest$num ] ; then
    continue
  fi
  for i in ${!sizes[@]} ; do
    [[ ${sizes[i]} =~ contest$num ]] && size=${sizes[$(($i-1))]} && break
  done
  if [ -f progress/progress$num ] ; then
    if [ -z $(grep ^\# progress/progress$num) ] ; then
      echo -n $bold
    fi
  fi
  filecount=$(find contest$num -type f | wc -l)
  echo "$(pad contest$num -12)-$(pad $filecount 8)$(pad $size 8)$normal"
  totalfiles=$(($totalfiles+$filecount))
done
echo "________________________________"
echo "$(pad total -12)-$(pad $totalfiles 8)$(pad ${sizes[-2]} 8)"
