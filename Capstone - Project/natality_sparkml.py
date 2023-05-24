"""Run a linear regression using Apache Spark ML.

In the following PySpark (Spark Python API) code, we take the following actions:

  * Load a previously created linear regression (BigQuery) input table
    into our Cloud Dataproc Spark cluster as an RDD (Resilient
    Distributed Dataset)
  * Transform the RDD into a Spark Dataframe
  * Vectorize the features on which the model will be trained
  * Compute a linear regression using Spark ML

"""
from pyspark.context import SparkContext
from pyspark.ml.linalg import Vectors
from pyspark.ml.regression import LinearRegression
from pyspark.sql.session import SparkSession
# The imports, above, allow us to access SparkML features specific to linear
# regression as well as the Vectors types.


# Define a function that collects the features of interest
# (mother_age, father_age, and gestation_weeks) into a vector.
# Package the vector in a tuple containing the label (`weight_pounds`) for that
# row.
def vector_from_inputs(r):
  return (r["weight_pounds"], Vectors.dense(float(r["mother_age"]),
                                            float(r["father_age"]),
                                            float(r["gestation_weeks"]),
                                            float(r["weight_gain_pounds"]),
                                            float(r["apgar_5min"])))

sc = SparkContext()
spark = SparkSession(sc)

# Read the data from BigQuery as a Spark Dataframe.
natality_data = spark.read.format("bigquery").option(
    "table", "natality_regression.regression_input").load()
# Create a view so that Spark SQL queries can be run against the data.
natality_data.createOrReplaceTempView("natality")

# As a precaution, run a query in Spark SQL to ensure no NULL values exist.
sql_query = """
SELECT *
from natality
where weight_pounds is not null
and mother_age is not null
and father_age is not null
and gestation_weeks is not null
"""
clean_data = spark.sql(sql_query)

# Create an input DataFrame for Spark ML using the above function.
training_data = clean_data.rdd.map(vector_from_inputs).toDF(["label",
                                                             "features"])
training_data.cache()

# Construct a new LinearRegression object and fit the training data.
lr = LinearRegression(maxIter=5, regParam=0.2, solver="normal")
model = lr.fit(training_data)
# Print the model summary.
print("Coefficients:" + str(model.coefficients))
print("Intercept:" + str(model.intercept))
print("R^2:" + str(model.summary.r2))
model.summary.residuals.show()


from pyspark.ml.regression import RandomForestRegressor
from pyspark.ml.evaluation import RegressionEvaluator

# Create a RandomForestRegressor
rf = RandomForestRegressor(numTrees=10)

# Train the model
model_rf = rf.fit(training_data)

# Make predictions on the training data
predictions = model_rf.transform(training_data)

# Evaluate the model. The default metric for the RegressionEvaluator is rmse (Root Mean Squared Error)
evaluator = RegressionEvaluator(labelCol="label", predictionCol="prediction")

# You can also choose other metrics like mse (Mean Squared Error), mae (Mean Absolute Error), r2 (R Square)
rmse = evaluator.evaluate(predictions)
mse = evaluator.evaluate(predictions, {evaluator.metricName: "mse"})
mae = evaluator.evaluate(predictions, {evaluator.metricName: "mae"})
r2 = evaluator.evaluate(predictions, {evaluator.metricName: "r2"})

print("Root Mean Squared Error (RMSE) on training data: %g" % rmse)
print("Mean Squared Error (MSE) on training data: %g" % mse)
print("Mean Absolute Error (MAE) on training data: %g" % mae)
print("R Square (R2) on training data: %g" % r2)

