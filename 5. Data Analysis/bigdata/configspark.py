from pyspark.sql import SparkSession
import os
import sys


class ConfigSpark:
    def __init__(self):
        os.environ['PYSPARK_PYTHON'] = sys.executable
        os.environ['PYSPARK_DRIVER_PYTHON'] = sys.executable

    def initializeSpark(self):
        spark = SparkSession.builder.master("local[*]").getOrCreate()
        sc = spark.sparkContext
        return spark, sc

    def quite_logs(self, sc):
        logger = sc._jvm.org.apache.log4j
        logger.LogManager.getLogger("org").setLevel(logger.Level.ERROR)
        logger.LogManager.getLogger("akka").setLevel(logger.Level.ERROR)
