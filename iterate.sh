#! /bin/bash

# number determines sub dir and test dir to use
assnum=4

# if largeoutputs == 1: print "make test" to file and do `less outputs`
# else: just do "make test"
largeoutputs=1

if [ -z $1 ] ; then
  echo "Usage: $0 <command>"
  echo "commands:"
  echo "ssh     - print ssh-agent instructions"
  echo "clear   - each repo do  -> rm -rf * ; git reset --hard HEAD ;"
  echo "pull    - eacho repo do -> above command + git pull"
  echo "test    - in assgn dir, rm -rf makefile ./test ; cp -r test . ; print output of make test"
  echo "writeup - prints the writeup in the assignment dir of each repo"
  echo "date    - prints the top date from the git log of each repo"
  echo "dir     - attempts to move to assignment directory for each repo"
  exit 0
fi

if [ $1 == "ssh" ] ; then
  echo "do:"
  echo "eval \`ssh-agent\`"
  echo "ssh-add"
  exit 0
fi

### Skip past beginning of the list (also skips this directory)
skipto=0
#skipdir="badrepo"

declare -A excludedirs
declare -A selectdirs

### only do a partial run, (list the dir names)
dopartial=0
if [ $dopartial == 1 ]; then
  for name in repo1 repo2 ... ; do
    selectdirs["${name}/"]=1
  done
fi

### exclude these dirs (can add additional dirnames)
# always exclude: "." ".." "templates" "tests" "sol" "mine"
for name in . .. templates tests sol mine ; do
  excludedirs["${name}/"]=1
done

# current directory
base=$(dirname $(realpath 0))

# iterate through the directories
for dir in */ .*/ ; do
  if [[ ${excludedirs["$dir"]} -ne 1 ]]; then
    if [ $skipto == 1 ]; then
      echo $dir
      if [ $dir == "${skipdir}/" ]; then
        skipto=0
      fi
      continue
    fi
    if [ $dopartial == 1 ] && [[ ${selectdirs["$dir"]} -ne 1 ]]; then
      continue
    fi
    cd ${base}/${dir}
    if [ $1 == "clear" ]; then
      rm -rf *
      git reset --hard HEAD
    elif [ $1 == "pull" ]; then
      rm -rf *
      git reset --hard HEAD
      git checkout master
      git pull
    elif [ $1 == "test" ]; then
      echo "########"
      echo "##################"
      echo "####################################"
      echo ${dir}
      cd assgn${assnum}
      rm -rf makefile ./test/
      cp -r ${base}/tests/asgn${assnum}/* .
      make clean
      if [ $largeoutputs == 1 ] ; then
        echo ${dir} > testoutput
        make test >> testoutput
        less testoutput
      else
        echo ${dir}
        make test
      fi
      echo "####################################"
      read -n 1 -p "above was ${dir::-1}, press the enter key to continue . . . " dummyval
      clear
    elif [ $1 == "writeup" ]; then
      echo "########"
      echo "##################"
      echo "####################################"
      echo ${dir}
      cd assgn${assnum} && cat writeup.txt || echo "${dir} missing writeup.txt at correct location"
      read -n 1 -p "${dir::-1} press the enter key to continue . . . " dummyval
    elif [ $1 == "date" ]; then
      echo ${dir}
      git log | head -n 4 | tail -n 3
    elif [ $1 == "dir" ]; then
      cd assgn${assnum} 2> /dev/null || echo "${dir} does not have directory ./${dir}assgn${assnum}"
    fi
  fi
done

