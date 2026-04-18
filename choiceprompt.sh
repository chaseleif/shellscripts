#! /usr/bin/env bash

# getchoice variable choices
# $1  the variable is set to an element of choices
# $2+ is the list of choices
getchoice() {
  local key index i
  local -r var="$1"
  shift
  local -r choices=("$@") maxindex="$((${#}-1))" mvcursorup="\e[${#}F"
  index=0
  # hide cursor
  printf "\e[?25l"
  # don't leave the cursor hidden
  trap 'printf "\e[?25h" ; trap - SIGINT ; kill -SIGINT $$' SIGINT
  trap 'printf "\e[?25h" ; trap - SIGTERM ; kill -SIGTERM $$' SIGTERM
  trap 'printf "\e[?25h" ; trap - SIGHUP ; kill -SIGHUP $$' SIGHUP
  while true ; do
    # FG green; BG black
    printf "\e[32;40m"
    for (( i=0; i<="$maxindex"; ++i )) ; do
      if [ "$i" -eq "$index" ] ; then
        # 1m bold 22m reset bold
        printf " \e[1m<%s>\e[22m\n" "${choices[i]}"
      else
        # 0K del cursor to end of line
        printf "  %s\e[0K\n" "${choices[i]}"
      fi
    done
    # reset color
    printf "\e[0m"
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
    # F move cursor to beginning of line # lines up
    printf "%b" "$mvcursorup"
  done
  # restore cursor
  printf "\e[?25h"
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
