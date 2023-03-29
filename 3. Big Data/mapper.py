#!/usr/bin/python3

import sys
# input comes from standard input
for line in sys.stdin:
	# remove the white spaces from both the ends
	line=line.strip()
	words=line.split()
	for word in words:
	# writes the u/p to the standard output
	# tab-delimited; the trivial word count is 1
	# o/p of the mapper job is i/p to the reducer
		print("{}\t{}".format(word,1))
