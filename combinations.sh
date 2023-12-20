#! /usr/bin/env bash

###
# Function to get the next combination
# Uses indices, returns -1 when no more combinations
###
# Index array and other values are automatically calculated.
# Just need to set the "choices" array
# Optionally set the "names" array and "sep" string, see below
###
function getcombo() {
  place=$((${#indices[@]}-1))
  indices[place]=$((indices[place]+1))
  while [ "${indices[place]}" -ge "${num_elements[place]}" ] ; do
    place=$((place-1))
    if [ "$place" -lt 0 ] ; then
      printf -v "$1" -- "-1"
      return
    fi
    indices[place]=$((indices[place]+1))
  done
  if [ "${indices[0]}" -ge "${num_elements[0]}" ] ; then
    printf -v "$1" -- "-1"
    return
  fi
  place=$((place+1))
  while [ "$place" -lt "${#indices[@]}" ] ; do
    indices[place]=0
    place=$((place+1))
  done
  place=$((place-1))
  printf -v "$1" -- "%d" "$((combonumber-1))"
}

###
# Arrays to choose from, each element is a space-separated string
# Each element of the string is a combination choice
# ***Each string should be in non-decreasing order***
choices=( "1 2 4"
          "8 16 32"
          "1000 2000 3000 4000")
# Optional pre-text for each choice
names=("--num_phases"
        "--num_epochs"
        "--mat_size")
# Optional separator to use
sep="="
###
# Result will be printed like: ${names[i]}${sep}${val[i]}
# Unsetting/removing names+sep will result in only values printed
# Each combination is printed on a line, space separated
###

###
# The rest of the values are automatically calculated
###
# Array to hold the number of elements
declare -a num_elements
# Array to hold the current printing indices
declare -a indices
###
# n, the number of arrays (minus 1)
n=-1
###
for i in $(seq 0 $((${#choices[@]}-1))) ; do
  n=$((n+1))
  read -ra vals <<< "${choices[i]}"
  num_elements+=(${#vals[@]})
  indices+=(0)
done
# Set the last index to -1, the first iteration will bring it to zero
indices[n]=$((indices[n]-1))

# The maximum number of combinations to get, used in while loop below
# To get all combinations, set this number to -1
# combonumber will be set to -1 when no combinations remain
combonumber=2

###
# Combinations loop
###
# Set the first combination indices (indices array becomes all zeroes)
getcombo combonumber
# Loop until we have the number of combinations or no more remaining
while [ "$combonumber" -ne -1 ] ; do
  # Print our combination
  combo=""
  for i in $(seq 0 "$n") ; do
    if [ "$i" -gt 0 ] ; then combo+=" " ; fi
    read -ra vals <<< "${choices[i]}"
    combo+="${names[i]}$sep${vals[${indices[i]}]}"
  done
  printf "%s\n" "$combo"
  # Get the next combination
  getcombo combonumber
done

###
# If getting a specific combination number
# Initialize combonumber to the number (at least 1)
# Then . . . the (original) combonumber combo is
echo "The final combo: $combo"

