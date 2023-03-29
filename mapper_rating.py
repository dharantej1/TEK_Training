#!/usr/bin/python3

import sys
# input comes from standard input
for line in sys.stdin:
        # remove the white spaces from both the ends
        line=line.strip()
        ratings=list(line.split(","))[-1]
        try:
		int(ratings)
		print("{}\t{}".format(ratings,1))
	except:
		continue
