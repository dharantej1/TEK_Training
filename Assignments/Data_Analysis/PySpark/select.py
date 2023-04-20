from pyspark.sql import SparkSession
from pyspark.sql.functions import lit

spark = SparkSession.builder.appName("Add Constant Column").getOrCreate()

trainDF = spark.read.csv("C:/workspace/Execise/train.csv", header=True, inferSchema=True)

trainDF = trainDF.select("*", lit(1).alias("ConstantOne"))

trainDF.show(3)

spark.stop()