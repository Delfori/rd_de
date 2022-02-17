import pyspark
from pyspark.sql import SparkSession
from pyspark.sql import Row


spark = SparkSession.builder.config("spark.jars", "/usr/local/postgresql-42.2.5.jar") \
    .master("local").appName("PySpark_Postgres_test").getOrCreate()


df = spark.read.format("jdbc").option("url", "jdbc:postgresql://localhost:5432/postgres") \
    .option("driver", "org.postgresql.Driver").option("dbtable", "drivers_data") \
    .option("user", "hduser").option("password", "bigdata").load()