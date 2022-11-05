import sys
import os

for line in sys.stdin:
    line = line.strip()
    wf,nN=line.split('\t',1)
    w,f=wf.split(' ',1)
    z=f+' '+nN+' '+str(1)
    print ('%s\t%s' % (w,z))

        