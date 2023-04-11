from configspark import ConfigSpark
"""
In this class we initialize the spark session using a config file
Run the spark program for the hello world

here we are getting the initialized values from the configspark.py file which is in the same folder
"""


class HwConfig:
    pass


if __name__ == '__main__':
    spConfig = ConfigSpark()
    spark, sc = spConfig.initializeSpark()
    spConfig.quite_logs(sc)
    data = ['Welcome to Pyspark', 'Hello World!!']
    rdd1 = sc.parallelize(data)
    print(rdd1.collect())
