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

price_list = []
asin_list = []
# Adding all the prices and asin to 2 lists to make RDD later
for post in db["new_kindle_metadata"].find():
    if "price" in post:
        price_list.append(post["price"])
    else:
        price_list.append("NP")
    asin_list.append(post["asin"])

print(price_list[:30])
print(asin_list[:30])



sc = pyspark.SparkContext("spark://172.2.0.147:7077", "Correlation")
spark = SparkSession(sc).builder.master("172.2.0.147").appName("HELLO") \
         .config("spark.mongodb.input.uri", "mongodb://user:password@13.212.212.123:27017") \
            .config('spark.driver.extraClassPath', '/opt/spark-3.0.1-bin-hadoop3.2/jars/*;/opt/spark-3.0.1-bin-hadoop3.2/bin/pyspark') \
               .config('spark.jars.packages', 'org.mongodb.spark:mongo-spark-connector_2.11:2.4.2') \
                  .getOrCreate()






# Parquet stuff
reviews = spark.read.parquet("hdfs://172.2.0.147:9000/user/hadoop/KRTable/9d5d6615-68be-427e-b214-b3be7549880e.parquet")
#DataFrame[id: int, asin: string, helpful: string, overall: int, reviewText: string, reviewTime: string, reviewerID: string, reviewerNam$
#reviews.show(5)


# spark mongo if got time

#meta = spark.read.format("mongo").option("uri", "mongodb://user:password@13.212.212.123:27017/user.metadatas?authSource=user").load()
#meta.printSchema()

#df = spark.read.format("com.mongodb.spark.sql.DefaultSource").load()
#df.printSchema()

price_rdd = spark.sparkContext.parallelize(price_list)
asin_rdd = spark.sparkContext.parallelize(asin_list)

price_row = Row("price")
asin_row = Row("asin")


price_db = price_rdd.map(price_row).toDF()
asin_db = asin_rdd.map(asin_row).toDF()


price_db.show(5)
asin_db.show(5)

# Join tgt to get meta_table
print("Meta_table")
#meta_table = price_db.join(asin_db, how='right_outer')
meta_table = price_db.join(asin_db, how='full')
meta_table.show(10)



asindb = reviews.select('asin','reviewText')

asindb_len = asindb.withColumn('reviewLength', fns.length('reviewText'))
#asindb_len.show(5)

# Group tgt average length by asin
asin_avglen = asindb_len.groupBy('asin').avg('reviewLength')
#asin_avglen.show(5)


ultra_table = asin_avglen.join(price_db)
print("ULTRA_TABLE!#!@#")
ultra_table.show(10)



