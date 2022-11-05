import operator
import sys

c_wrd = None
c_cnt = 0
word = None


for line in sys.stdin:
    line = line.strip()
    word, count = line.split('\t', 1)
    try:
        count = int(count)
    except:
        continue


    if c_wrd == word:
        c_cnt += count
    else:
        if c_wrd:
            # write result to STDOUT
            print ('%s\t%s' % (c_wrd, c_cnt))
        c_cnt = count
        c_wrd = word

if c_wrd == word:
    print ('%s\t%s' % (c_wrd, c_cnt))