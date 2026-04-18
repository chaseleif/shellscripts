#! /usr/bin/env bash

# getchoice varname "${choices[@]}"
getchoice() {
  # the variable to set is the first argument
  local -r var="$1" ; shift
  if [[ ! $var =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] ; then
    printf "\"%s\" is not a valid variable name\n" "$var"
    return
  fi
  # the choices are the remainder of arguments
  if [ "$#" -eq 0 ] ; then
    printf "There are no choices to choose from to set %s\n" "$var"
    return
  fi
  local key index i signal
  local -r choices=("$@") maxindex="$((${#}-1))" mvcursorup="\e[${#}F"
  # save existing traps to restore them
  local -r intfn="$(trap -p SIGINT)"
  local -r termfn="$(trap -p SIGTERM)"
  local -r hupfn="$(trap -p SIGHUP)"
  # trap signals to restore state
  trap 'signal="SIGINT"' SIGINT
  trap 'signal="SIGTERM"' SIGTERM
  trap 'signal="SIGHUP"' SIGHUP
  # hide cursor, FG green ; BG black
  printf "\e[?25l\e[32;40m"
  # get a choice
  index=0
  while true ; do
    for (( i=0; i<="$maxindex"; ++i )) ; do
      if [ "$i" -eq "$index" ] ; then
        # 1m bold 22m reset bold
        printf " \e[1m<%s>\e[22m\n" "${choices[i]}"
      else
        # 0K del cursor to end of line
        printf "  %s\e[0K\n" "${choices[i]}"
      fi
    done
    while [ -z "$signal" ] ; do
      if IFS= read -r -s -n1 -t 0.2 key ; then
        [ -z "$key" ] && break
      fi
      if [ "$key" == $'\e' ] ; then
        IFS= read -r -s -n2 -t0.05 key
        if [ "$key" == '[A' ] && [ "$index" -gt 0 ] ; then
          ((--index))
          break
        elif [ "$key" == '[B' ] && [ "$index" -lt "$maxindex" ] ; then
          ((++index))
          break
        fi
      fi
    done
    [[ -n "$signal" || -z "$key" ]] && break
    # nF move cursor to beginning of line n lines up
    printf "%b" "$mvcursorup"
  done
  # restore state
  # remove our traps
  trap - SIGINT SIGTERM SIGHUP
  # restore the cursor and reset the color
  printf "\e[?25h\e[0m"
  # restore any previous traps
  [ -n "$intfn" ] && eval "$intfn"
  [ -n "$termfn" ] && eval "$termfn"
  [ -n "$hupfn" ] && eval "$hupfn"
  # reraise signal
  if [ -n "$signal" ] ; then
    kill -"$signal" "$$"
  # put choice into variable
  else
    printf -v "$var" "%s" "${choices[$index]}"
  fi
}

if false ; then
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
fi
