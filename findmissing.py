#! /usr/bin/env python3

'''
I used this script to find which trials still need to be done.
It goes through all folders in the current directory,
the test directories all started with 'A' or 'G'.
Each folder should have a node1, node2, and node4 output.
Folders that don't have some output are printed grouped together.
'''

import os

base = os.getcwd()
files = os.listdir(base)

node1 = []
node2 = []
node4 = []
for filename in files:
  if not os.path.isdir(base+'/'+filename): continue
  if not filename.startswith('A') and not filename.startswith('G'):
    continue
  #if 'TD' in filename: continue
  #if 'TD' not in filename: continue
  ls = os.listdir(base+'/'+filename)
  #print(filename)
  #print(ls)
  if not 'node1' in ls:
    node1.append(filename)
  if not 'node2' in ls:
    node2.append(filename)
  if not 'node4' in ls:
    node4.append(filename)

missing = {}
missing['1'] = []
missing['1,2'] = []
missing['1,4'] = []
missing['2'] = []
missing['2,4'] = []
missing['all'] = []
for name in node1:
  if name in node2 and name in node4:
    missing['all'].append(name)
    node2.remove(name)
    node4.remove(name)
  elif name in node2:
    missing['1,2'].append(name)
    node2.remove(name)
  elif name in node4:
    missing['1,4'].append(name)
    node4.remove(name)
  else:
    missing['1'].append(name)

for name in node2:
  if name in node4:
    node4.remove(name)
    missing['2,4'].append(name)
  else:
    missing['2'].append(name)

missing['4'] = [name for name in node4]

for key in missing:
  if len(missing[key])==0: continue
  print('Missing '+key+':')
  print(missing[key])

