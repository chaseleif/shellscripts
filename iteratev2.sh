#! /usr/bin/env bash

if [ -z $1 ] ; then
  echo "Usage: $0 <command>"
  echo "commands:"
  echo "ssh     - print ssh-agent instructions"
  echo "clear   - each repo do  -> rm -rf * ; git reset --hard HEAD ;"
  echo "grades  - create a grades text file with each dir (repo) name"
  echo "pull    - each repo do -> above command + git pull"
  echo "test    - each repo dp \"ls\" then enter a loop to input commands until \"c\" for continue"
  echo "dir     - same as test, but do not copy testing files"
  echo "date    - prints the top date from the git log of each repo"
  exit 0
fi

if [ $1 == "ssh" ] ; then
  echo "do:"
  echo "eval \`ssh-agent\`"
  echo "ssh-add"
  exit 0
fi

alias diff01="diff input0_32_1_soln.txt "
alias diff02="diff input0_1024_1_soln.txt "
alias diff11="diff input1_16_1_soln.txt "
alias diff12="diff input1_16_2_soln.txt "
alias diff21="diff input2_4_1_soln.txt "
alias diff22="diff input2_8_1_soln.txt "
alias diff31="diff input3_4_1_soln.txt "
alias diff32="diff input3_4096_32_soln.txt "
alias diff41="diff input4_2_1_soln.txt "
alias diff42="diff input4_4_2_soln.txt "
alias test01="./a.out 32 1 input0"
alias test02="./a.out 1024 1 input0"
alias test11="./a.out 16 1 input1"
alias test12="./a.out 16 2 input1"
alias test21="./a.out 4 1 input2"
alias test22="./a.out 8 1 input2"
alias test31="./a.out 4 1 input3"
alias test32="./a.out 4096 32 input3"
alias test41="./a.out 2 1 input4"
alias test42="./a.out 4 2 input4"

### Skip past beginning of the list to this directory
skipto=0
skipdir="thisdir"

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
# always exclude: "." ".." "templates" "tests" "sol"
for name in . .. tests docs samplecode ; do
  excludedirs["${name}/"]=1
done

# current directory
base=$(pwd)

if [ $1 == "grades" ] ; then
  rm -f grades
fi

# iterate through the directories
for dir in */ .*/ ; do
  if [[ ${excludedirs["$dir"]} -ne 1 ]]; then
    if [ $skipto == 1 ]; then
      echo $dir
      if [ $dir == "${skipdir}/" ]; then
        skipto=0
      else continue
      fi
    fi
    if [ $dopartial == 1 ] && [[ ${selectdirs["$dir"]} -ne 1 ]]; then
      continue
    fi
    cd ${base}/${dir}
    if [ $1 == "clear" ]; then
      if [[ -d "original" ]]; then
        echo "${dir} has a folder with original files, not a repo, skipping . . ."
        continue
      fi
      rm -rf *
      git reset --hard HEAD
      rm -f a.out
    elif [ $1 == "grades" ]; then
      cd ../
      echo ${dir} >> grades
      echo "" >> grades
    elif [ $1 == "pull" ]; then
      if [[ -d "original" ]]; then
        echo "${dir} has a folder with original files, not a repo, skipping . . ."
        continue
      fi
      rm -rf *
      git reset --hard HEAD
      git checkout master
      git pull
    elif [[ $1 == "test" ]] || [[ $1 == "dir" ]]; then
      if [ $1 != "dir" ]; then
        cp -r ${base}/tests/* .
      fi
      echo ${dir}
      thecmd="ls"
      while [ "$thecmd" != "c" ] ; do
        if [ "${thecmd}" == "ls" ] ; then
          echo "########"
          echo "##################"
          echo "####################################"
          echo "Enter command \"cmds\" for the list"
          echo ${dir}
        elif [ "${thecmd}" == "cmds" ] ; then
          clear
          echo "########"
          echo "##################"
          echo "####################################"
          echo "Commands for 5 input files, 0-4"
          echo "Each input file has 2 tests"
          echo "First compile program to \"./a.out\""
          echo "Then run \"test01\" to run test 1 on input file 0"
          echo "Then run \"diff01 <filename>\" to diff that output"
          thecmd="ls"
          continue
        elif [[ ! -z "${BASH_ALIASES[$(echo ${thecmd} | awk '{print $1}')]}" ]] ; then
          thecmd="${BASH_ALIASES[$(echo ${thecmd} | awk '{print $1}')]} $(echo ${thecmd} | awk '{print $2}')"
        fi
        while ! ${thecmd} 2>&1 ; do
          echo "${thecmd} failed :("
          break
        done
        read -p "Enter command or \"c\" to continue: " thecmd
      done
      echo "####################################"
      clear
    elif [ $1 == "date" ]; then
      echo ${dir}
      if [[ -d "original" ]]; then
        echo "${dir} has a folder with original files, not a repo, skipping . . ."
        echo ""
        continue
      fi
      git log | head -n 4 | tail -n 3
    fi
  fi
done

