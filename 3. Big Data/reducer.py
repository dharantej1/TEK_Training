#!/usr/bin/python3

from operator import itemgetter
import sys

current_word=None
current_count=0
word=None

# input comes from stdin
for line in sys.stdin:
	line=line.strip()
	
	# parse the input we got from mapper.py
	# word and count are separated by <tab> delimited
	# 1 -> no of splits
	word, count=line.split("\t",1)

	# convert count (currently the string) to integer data
	try:
		count=int(count)
	except ValueError:
		# count was not a number, so silently discard this line
		continue
	# this if-switch only works because hadoop starts map o/p
	# by key (here: word) before it is passed to the reducer
	if current_word==word:
		current_count+=count
	else:
		if current_word:
		# write result to stdoutput separated by tab
			print("{}\t{}".format(current_word, current_count))
		current_count=count
		current_word=word
# do not forget to o/p the last word if needed!
if current_word==word:
	print("{}\t{}".format(current_word, current_count))	

# cat /home/hadoop/Downloads/HarryPotter_Sorcerers_Stone.txt | python3 mapper.py

# cat /home/hadoop/Downloads/HarryPotter_Sorcerers_Stone.txt | python3 mapper.py | sort | python3 reducer.py

# hadoop jar /usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.7.6.jar -file mapper.py -mapper /home/hadoop/mapper.py -file reducer.py -reducer /home/hadoop/reducer.py -input /wordcount/HarryPotter_Sorcerers_Stone.txt -output /wordcount_op

	
