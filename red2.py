import operator
import sys

c_wrd = None
prvfile = None
c_cnt = 0
word = None
N=0
dicts={}
lst=[]


for line in sys.stdin:
    line = line.strip()
    lst.append(line)
    filename,wordcount = line.split('\t', 1)
    word,count = wordcount.split(' ', 1)
    count=int(count)
    if prvfile == filename:
        N=N+count
    else:
       if prvfile != None:
            dicts[prvfile]=N
       N=0
       prvfile = filename
dicts[prvfile]=N


for h in lst:
    filename,wordcount = h.split('\t', 1)
    word,count = wordcount.split(' ', 1) 
    for k in dicts:
        if filename == k:
           wrdfre=word+' '+filename
           totcnt=count+' '+str(dicts[k])
           print ('%s\t%s' % (wrdfre,totcnt))
    