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
#HDFS_ADDR = f"hdfs://{IP_ADDR}:9000"
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

sc = pyspark.SparkContext("spark://172.2.0.147:7077", "Correlation")
spark = SparkSession(sc)

review = spark.read.parquet("hdfs://172.2.0.147:9000/user/hadoop/KRTable/9d5d6615-68be-427e-b214-b3be7549880e.parquet")




#asindb = reviews1.select('asin','reviewText')
#asindb_len = asindb.withColumn('reviewLength', fns.length('reviewText'))




