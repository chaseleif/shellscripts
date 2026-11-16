#! /usr/bin/env bash

print_usage() {
  [ -n "$1" ] && printf "%s\n" "$@"
  printf "Usage: %s a/ b/\n" "${BASH_SOURCE[0]}"
  exit
}

a="$1"
shift
b="$1"
shift
if [ -z "$a" ] || [ -z "$b" ] ; then
  print_usage "No directories to compare"
elif [ ! -d "$a" ] ; then
  print_usage "\"$a\" is not a valid directory"
elif [ ! -d "$b" ] ; then
  print_usage "\"$b\" is not a valid directory"
fi

hline="------------------------------"

printf "%s\n" "$hline"
printf "  +a: only found in a\n"
printf "a!=b: file in a differs from b\n"
printf "  +b: only found in b\n"
printf "%s\n\n" "$hline"
printf "a=%s\nb=%s\n" "$a" "$b"
a="$(realpath "$a")"
b="$(realpath "$b")"

cd "$a" || exit

# ignore all files and directories that begin with a period
# -path "*/.*" -prune -or
mapfile -d '' files < <(find . -path "*/.*" -prune -or -type f -print0)
for name in "${files[@]}" ; do
  if [ ! -f "$b/$name" ] ; then
    printf "  +a: %s\n" "$name"
  elif ! diff -q "$name" "$b/$name" >/dev/null 2>&1 ; then
    printf "a!=b: %s\n" "$name"
  fi
done
cd "$b" || exit
mapfile -d '' files < <(find . -path "*/.*" -prune -or -type f -print0)
for name in "${files[@]}" ; do
  if [ ! -f "$a/$name" ] ; then
    printf "  +b: %s\n" "$name"
  fi
done
printf "%s\n" "$hline"
