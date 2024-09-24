#! /usr/bin/env python3

import hashlib, os, re, sys

''' hashfiles
    Gets the md5sum of all files within the path
    arguments
    path:         the root path, considers all files within and below the root
    excludefiles: list of strings to use with re.fullmatch
                  matching files will be skipped
    returns -> dict[md5sum] = [file1, ...]
'''
def hashfiles(path, excludefiles=[]):
  # md5sums of files found
  hashes = {}
  # All files within the path
  for base, _, files in os.walk(path):
    for file in files:
      if any([re.fullmatch(exclude, file) for exclude in excludefiles]):
        continue
      # Gather md5sums
      filename = os.path.join(base, file)
      with open(filename,'rb') as infile:
        md5 = hashlib.md5(infile.read()).hexdigest()
      if md5 not in hashes: hashes[md5] = []
      hashes[md5].append(filename)
  return hashes

if __name__ == '__main__':
  # Files to exclude from hash equality checks
  # the left-side of re.fullmatch() with the filename in the right-side
  excludefiles=['[mM]akefile','driver',r'y\..*','Inclass',r'.*\.pdf',
                '[wW][rR][iI][tT][eE][uU][pP]',r'.*\.o','[eE][aA][dD]'
                ,'PaxHeader']
  if len(sys.argv) == 1 or not os.path.isdir(sys.argv[1]):
    path = os.path.dirname(os.path.realpath(__file__))
  else:
    path = sys.argv[1]
  # get the hashes
  hashes = hashfiles(path, excludefiles)
  # for each md5sum
  for md5 in hashes:
    # unique files will have a unique hash
    if len(hashes[md5]) == 1: continue
    # (probable) duplicate files will have the same hash
    print(f'Duplicate files: {md5=}')
    for file in hashes[md5]:
      print(file)
    print()

