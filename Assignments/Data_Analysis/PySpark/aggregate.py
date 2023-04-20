from pyspark.sql import SparkSession
from pyspark.sql.functions import *

spark = SparkSession.builder.appName("Aggregate Operations").getOrCreate()

df = spark.read.csv("C:/workspace/Exercise/train.csv", header=True, inferSchema=True)

df_count = df.groupBy("SameCategoryCode").count()

df_count.show()

df_avg = df.agg(avg("Value").alias("AvgValue"))

df_avg.show()

spark.stop()