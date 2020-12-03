import pyspark
from pyspark.sql import SparkSession
import pyspark.sql.functions as fns
import sys
import os
import pymongo
import pprint


# Usage: python3 pearson.py $MASTER 1603420304
# OR 
# python3 pearson.py ec2-52-221-250-84.ap-southeast-1.compute.amazonaws.com 1603420304

IP_ADDR = sys.argv[1]
asin = sys.argv[2]

#HDFS_ADDR = f"hdfs://ec2-{IP_ADDR}.compute-1.amazonaws.com:9000"
HDFS_ADDR = f"hdfs://{IP_ADDR}:9000"
mongo_username = "user"
mongo_password = "password"



client = pymongo.MongoClient("mongodb://"+ IP_ADDR +":27017")
print("Client passed")
auth = client.admin.authenticate(mongo_username,mongo_password)
print("Auth passed")
db = client["myMongodb"]
print("DB passed")

for post in db["new_kindle_metadata"].find({"asin" : asin}):
    pprint.pprint(post)
    print(post["price"]) # This gives 7.69, type "str".

#TODO get review length using pyspark from HDFS from sqoop and calculate.



sc = pyspark.SparkContext(f"spark://ec2-{IP_ADDR}.compute-1.amazonaws.com:7077", "Correlation")
spark = SparkSession(sc)

# Read in reviews
reviews = spark.read.csv(f"{HDFS_ADDR}/datasets/kindle_reviews.csv", header=True)

# Select by asin
asinr = reviews.select('asin','reviewText')
# Get length of reviews
asinrl = asinr.withColumn('reviewLength',fns.length('reviewText'))

# Read Metadata
meta = spark.read.json(f"{HDFS_ADDR}/datasets/meta_Kindle_Store.json")

# Get avg length of reviews by asin
asin_avgl = asinrl.groupBy('asin').avg('reviewLength')

# Join asin_avgl and meta with column asin
table = asin_avgl.join(meta.select('asin', 'price'), ['asin'])

# Return Column for the Pearson Correlation Coefficient 
table = table.agg(fns.corr('avg(reviewLength)', "price").alias('pearson_correlation'))

table.select("pearson_correlation").show()

spark.stop()
