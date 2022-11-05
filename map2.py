import sys

for line in sys.stdin:
    line = line.strip()
    wordfilename,count=line.split('\t',1)
    word,filename=wordfilename.split(' ',1)
    last=word+' '+count;
    print ('%s\t%s' % (filename, last))