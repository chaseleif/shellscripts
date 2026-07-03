#! /usr/bin/env bash

# getchoice varname "${choices[@]}"
getchoice() {
  # the variable to set is the first argument
  local -r var="$1" ; shift
  # ensure valid variable name
  if [[ ! $var =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] ; then
    printf "\"%s\" is not a valid variable name\n" "$var"
    return
  fi
  # the choices are the remainder of arguments
  if [ "$#" -eq 0 ] ; then
    printf "There are no choices to choose from to set %s\n" "$var"
    return
  fi
  # save existing traps to restore them
  local -r intfn="$(trap -p SIGINT)"
  local -r termfn="$(trap -p SIGTERM)"
  local -r hupfn="$(trap -p SIGHUP)"
  # trap signals to restore state
  trap 'signal="SIGINT"' SIGINT
  trap 'signal="SIGTERM"' SIGTERM
  trap 'signal="SIGHUP"' SIGHUP
  # constants
  local -r choices=("$@") maxindex="$((${#}-1))" mvcursorup="\e[${#}F"
  # variables
  local key index i signal
  # hide cursor, FG green ; BG black
  printf "\e[?25l\e[32;40m"
  # we start with index zero
  index=0
  # loop to paint options, all options should fit in the screen
  while true ; do
    # we start at the row/col of the first choice, print each choice
    for (( i=0; i<="$maxindex"; ++i )) ; do
      if [ "$i" -eq "$index" ] ; then
        # highlight the active selection: 1m bold 22m reset bold
        printf " \e[1m<%s>\e[22m\n" "${choices[i]}"
      else
        # overwrite any prior highlight: 0K del cursor to end of line
        printf "  %s\e[0K\n" "${choices[i]}"
      fi
    done
    # get a key, either to move the active row or choose the active row
    while [ -z "$signal" ] ; do
      # read with a timeout, otherwise signals hang until some input received
      if IFS= read -r -s -n1 -t 0.2 key ; then
        # `key` will be empty when enter is pressed
        [ -z "$key" ] && break
        # start of a command char
        if [ "$key" == $'\e' ] ; then
          # get the remainder of the input and handle directional keys
          IFS= read -r -s -n2 -t0.05 key
          # if the active selection changes we need to repaint the choices
          # up
          if [ "$key" == '[A' ] && [ "$index" -gt 0 ] ; then
            ((--index))
            break
          # home
          elif [ "$key" == '[H' ] && [ "$index" -gt 0 ] ; then
            index=0
            break
          # down
          elif [ "$key" == '[B' ] && [ "$index" -lt "$maxindex" ] ; then
            ((++index))
            break
          # end
          elif [ "$key" == '[F' ] && [ "$index" -lt "$maxindex" ] ; then
            index="$maxindex"
            break
          fi
        fi
      fi
    done
    # we received a signal or the key is empty (index was chosen)
    [[ -n "$signal" || -z "$key" ]] && break
    # nF move cursor to beginning of line n lines up
    printf "%b" "$mvcursorup"
  done
  # remove our traps
  trap - SIGINT SIGTERM SIGHUP
  # restore the cursor and reset the color
  printf "\e[?25h\e[0m"
  # restore any previous traps
  [ -n "$intfn" ] && eval "$intfn"
  [ -n "$termfn" ] && eval "$termfn"
  [ -n "$hupfn" ] && eval "$hupfn"
  # reraise a signal if we trapped one
  if [ -n "$signal" ] ; then
    kill -"$signal" "$$"
  # put the choice into the variable
  else
    printf -v "$var" "%s" "${choices[$index]}"
  fi
}

if false ; then
  # sample usage
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
