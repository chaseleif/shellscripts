#! /usr/bin/env python3

# Gather a list of imports from Python files within a basepath
# standalone or feeds the companion script listimports4pip.sh

import os, re, sys

def findmodules(basepath):
  fromstmt = re.compile(r'^from\s+(\w+)\s+import')
  importstmt = re.compile(r'^import\s+(\w+)\s*(,(\s*\w+)\s*)*')
  imports = set()
  for root, dirs, files in os.walk(basepath):
    for file in files:
      if not file.endswith('.py'): continue
      if os.path.samefile(os.path.join(root,file), __file__): continue
      with open(os.path.join(root,file),'r') as infile:
        filecontents = [line.strip() for line in infile.readlines()]
      for line in filecontents:
        match = fromstmt.match(line)
        if match:
          imports.add(match.groups()[0])
          continue
        match = importstmt.match(line)
        if match:
          match = [module.strip() \
                    for module in line[6:match.span()[1]].split(',')]
          for module in match:
            imports.add(module)
  for module in imports:
    print(module)

if __name__ == '__main__':
  if len(sys.argv) == 2 and os.path.isdir(sys.argv[1]):
    findmodules(sys.argv[1])
  else:
    findmodules(os.getcwd())
