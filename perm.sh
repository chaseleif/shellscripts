#! /usr/bin/env bash

chmod 775 .
find . -type d -exec chmod 775 {} \;

rm -f executablefiles
touch executablefiles
find . -type f -executable -exec echo {} >> executablefiles \;
find . -type f -exec chmod 664 {} \;

while read p ; do
  chmod 775 "$p"
done < executablefiles
