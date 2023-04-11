"""
    here are are initializing the variables in the same file
"""
from pyspark.sql import SparkSession
import os
import sys

"""
This class tells us how to run the spark hello world program
"""


class HelloWorld:
    def __init__(self):
        os.environ['PYSPARK_PYTHON'] = sys.executable
        os.environ['PYSPARK_DRIVER_PYTHON'] = sys.executable

    def initSpark(self):
        spark = SparkSession.builder.master('local[*]').getOrCreate()
        sc = spark.sparkContext
        return spark, sc


if __name__ == '__main__':
    hworld = HelloWorld()
    spark, sc = hworld.initSpark()
    data = ['Welcome to Spark', 'Hello World!!']
    rdd1 = sc.parallelize(data)
    print(rdd1.collect())
