#! /usr/bin/env bash

# getchoice variable choices
# $1  the variable is set to an element of choices
# $2+ is the list of choices
getchoice() {
  local key index i
  local -r var="$1"
  shift
  local -r choices=("$@") maxindex="$((${#}-1))" clrlines="\e[${#}A"
  index=0
  while true ; do
    for (( i=0; i<="$maxindex"; ++i )) ; do
      if [ "$i" -eq "$index" ] ; then
        echo -e "~>\e[7m${choices[i]}\e[0m"
      else
        echo "  ${choices[i]}"
      fi
    done
    while true ; do
      IFS= read -r -s -n1 key
      [ "$key" == "" ] && break
      if [ "$key" == $'\e' ] ; then
        IFS= read -r -s -n2 -t0.001 key
        if [ "$key" == '[A' ] && [ "$index" -gt 0 ] ; then
          ((--index))
          break
        elif [ "$key" == '[B' ] && [ "$index" -lt "$maxindex" ] ; then
          ((++index))
          break
        fi
      fi
    done
    [ "$key" == "" ] && break
    echo -en "$clrlines"
  done
  printf -v "$var" "%s" "${choices[$index]}"
}
choices=(
  "yes"
  "no"
  "maybe"
  "skip"
)

echo "Well?"
choice="skip"
getchoice choice "${choices[@]}"

case "$choice" in
  "yes")   echo "ok!"  ;;
  "no")    echo "ok.." ;;
  "maybe") echo "ok?"  ;;
  "skip")  echo "fine" ;;
esac
