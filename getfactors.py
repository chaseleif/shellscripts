#! /usr/bin/env python3

from math import sqrt

def factors(n):
  for i in range(1, int(sqrt(n))+1):
    if n%i == 0:
      yield i

def printfactors(n):
  for factor in factors(n):
    print(f'{factor} * {n//factor} = {n}')

if __name__ == '__main__':
  import sys
  try:
    n = int(sys.argv[1])
  except:
    n = 42
  printfactors(n)
