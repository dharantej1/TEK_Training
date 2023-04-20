from pyspark import SparkContext, SparkConf

conf = SparkConf().setAppName("WordCount")
sc = SparkContext(conf=conf)

inputRdd = sc.textFile("C:\workspace\Exercise\input.txt")

wordRdd = inputRdd.flatMap(lambda x: x.split(' ')).map(lambda word: (word,1)).reduceByKey(lambda a,b: a+b)

output = wordRdd.collect()

for word, count in output:
    print("{}: {}".format(word,count))

sc.stop()

sc.stop()