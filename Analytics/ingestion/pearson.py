import pyspark
from pyspark.sql import SparkSession
import pyspark.sql.functions as fns
import sys
import os
import pymongo
import pprint

spark = SparkSession.builder.master("com.analytics.namenode") \
        .config("spark.mongodb.input.uri", "mongodb://userdb20:passworddb20@54.255.252.64:27017/myMongodb.new_kindle_metadata?authSource=admin") \
        .config("spark.mongodb.output.uri", "mongodb://userdb20:passworddb20@54.255.252.64:27017/myMongodb.new_kindle_metadata?authSource=admin") \
        .config('spark.jars.packages', 'org.mongodb.spark:mongo-spark-connector_2.12:3.0.0').config("spark.master", "local").getOrCreate()

df = spark.read.format("mongo") \
     .option("uri","mongodb://userdb20:passworddb20@54.255.252.64:27017/myMongodb.new_kindle_metadata?authSource=admin").load()


# Parquet stuff
reviews = spark.read.parquet("hdfs://com.analytics.namenode:9000/user/hadoop/KRTable/2c90d4ad-d10f-47eb-9fc3-fc83611ff588.parquet")
#DataFrame[id: int, asin: string, helpful: string, overall: int, reviewText: string, reviewTime: string, reviewerID: string, reviewerNam$
#reviews.show(5)



asindb = reviews.select('asin','reviewText')

asindb_len = asindb.withColumn('reviewLength', fns.length('reviewText'))
#asindb_len.show(5)

# Group tgt average length by asin
asin_avglen = asindb_len.groupBy('asin').avg('reviewLength')
#asin_avglen.show(5)



# Join table
table = asin_avglen.join(df.select('asin', 'price'), ['asin'])
#print("Table show")
#table.show(5)

# Return column for Pearson
table = table.agg(fns.corr('avg(reviewLength)', 'price').alias('pearson_coefficient'))
print("Final Table")
table.show()
