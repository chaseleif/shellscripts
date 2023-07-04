#! /usr/bin/env bash

# Adapted from comments at gist.github.com/stephenhardy/5470814

clearrepo() {
  cd "$1" || exit
  # New orphan branch
  git checkout --orphan newmain
  # Add everything
  git add -A
  # Delete main
  git branch -D main
  # Move to main
  git branch -m main
  # Commit
  git commit -m "Clearing history"
  # Force push
  git push -f --set-upstream origin main
  # Prune
  git gc --aggressive --prune=all
}

if ! [ -d "${1}" ] || [ -z "${1}" ] ; then
  echo "\"${1}\" is not a valid directory name"
  exit 0
fi

read -r -p "Really make \"${1}\" the new head with no history? [y/n] " confirm

case ${confirm} in
  [yY] )
    clearrepo "${1}" ;;
  [yY][eE][sS] )
    clearrepo "${1}" ;;
  * )
    echo "Not confirmed, not making changes . . ."
esac

