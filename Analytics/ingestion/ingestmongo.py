import sys
import pyspark
from pyspark.sql import SparkSession


# Get MongoDB Hostname
MONGODB_HOSTNAME = sys.argv[1]

# Ingest data from MongoDB to HDFS
spark = SparkSession.builder.master("com.analytics.namenode") \
		.config("spark.mongodb.input.uri", "mongodb://userdb20:passworddb20@" + MONGODB_HOSTNAME + ":27017/myMongodb.new_kindle_metadata?authSource=admin") \
		.config("spark.mongodb.output.uri", "mongodb://userdb20:passworddb20@" + MONGODB_HOSTNAME + ":27017/myMongodb.new_kindle_metadata?authSource=admin") \
		.config('spark.jars.packages', 'org.mongodb.spark:mongo-spark-connector_2.12:3.0.0').config("spark.master", "local").getOrCreate()

df = spark.read.format("mongo") \
    .option("uri","mongodb://userdb20:passworddb20@" + MONGODB_HOSTNAME + ":27017/myMongodb.new_kindle_metadata?authSource=admin").load()

df.write.save("hdfs://com.analytics.namenode:9000/user/hadoop/kindle_metaData",format="json",mode="append")