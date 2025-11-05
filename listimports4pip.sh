#! /usr/bin/env bash

# companion script for listimports.py
# uses that script to generate a pip install command
# this script takes an optional path as an argument
# if no path is given, python scripts from the present directory are searched

echo -n "pip install"
for module in $(python3 listimports.py "$1") ; do
  python3 -c "import $module" 2>/dev/null || echo -n " $module"
done
echo ""
