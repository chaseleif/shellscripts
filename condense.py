#! /usr/bin/env python

## This script is used in conjuction with a shell script
## This script makes a condensed output file from many outputs

import sys, math

stats = {}
current = ''
havefields = False
fieldkeys = []
numreports=0
for line in sys.stdin:
    line=line.rstrip()
    if '###' in line or 'Finished' in line:
        pass
    elif '##' in line:
        current = line[3:]
        stats[current]= {}
        havefields=False
        fieldkeys=[]
        numreports=1
    elif havefields==False:
        word = ''
        i=0
        while i<len(line):
            if line[i]=='#':
                fieldkeys.append(word)
                word=''
                while i<len(line) and line[i]!=' ':
                    i+=1
            elif line[i]==' ' and len(word)>0:
                if i==len(line)-1 or line[i+1]==' ' or word[-1]=='%':
                    fieldkeys.append(word)
                    word=''
                elif i<len(line)-1:
                    word+=' '
            elif line[i]!=' ' or len(word)>0:
                word+=line[i]
            i+=1
        havefields=True
    elif 'Path' in line:
        numreports+=1
    else:
        words = line.split(' ')
        i=0
        path=''
        haveone=False
        for word in words:
            if len(word)==0:
                continue
            if i==0:
                if word in stats[current]:
                    haveone=True
                else:
                    stats[current][word]={}
                path=word
            elif fieldkeys[i]!='Avg':
                if haveone==True:
                    if 'Min' in fieldkeys[i] or 'min' in fieldkeys[i]:
                        if float(word)<stats[current][path][fieldkeys[i]]:
                            stats[current][path][fieldkeys[i]]=float(word)
                    elif 'Max' in fieldkeys[i] or 'max' in fieldkeys[i]:
                        if float(word)>stats[current][path][fieldkeys[i]]:
                            stats[current][path][fieldkeys[i]]=float(word)
                    elif '.count' in fieldkeys[i] or '.sum' in fieldkeys[i]:
                        stats[current][path][fieldkeys[i]]+=float(word)
                    elif 'Inclusive' in fieldkeys[i]:
                        stats[current][path][fieldkeys[i]]+=float(word)
                else:
                    stats[current][path][fieldkeys[i]]=float(word)
            i+=1

delkeys = {}
for query in stats:
    delkeys[query] = {}
    for path in stats[query]:
        if len(stats[query][path])==1:
            delkeys[query][path]=1
            continue
        count=0
        for field in stats[query][path]:
            if math.isnan(stats[query][path][field])==True:
                delkeys[query][path] = 1
                break
            if 'Max' in field and stats[query][path][field]<0.005:
                delkeys[query][path]=1
                break
            if count>0 and 'sum' in field:
                stats[query][path][field]/=count
                count=0
            elif 'count' in field:
                count=stats[query][path][field]
            elif 'Inclusive' in field:
                stats[query][path][field]/=numreports
for query in delkeys:
    for path in delkeys[query]:
        del stats[query][path]
for query in stats:
    print(query)
    buildstr = ""
    for path in stats[query]:
        for i, test in enumerate(stats[query][path]):
            if i>0:
                buildstr+=", "
            buildstr+=test
        break
    print(buildstr)
    for path in stats[query]:
        buildstr=path+" "
        for i, key in enumerate(stats[query][path]):
            if i>0:
                buildstr+=", "
            buildstr+=str(stats[query][path][key])
        print(buildstr)
