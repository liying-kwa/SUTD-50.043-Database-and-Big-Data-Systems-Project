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


#reviews1 = spark.read.csv("hdfs://172.2.0.147:9000/user/hadoop/KRTable/part-m-00000", header=True)
#reviews1 = sc.textFile("hdfs://172.2.0.147:9000/user/hadoop/KRTable/part-m-00000").collect()

#reviews1.show(n=2, truncate=False)
#reviews1.printSchema()

reviews0 = sc.textFile("hdfs://172.2.0.147:9000/user/hadoop/KRTable/part-m-00000").collect()
reviews1 = sc.textFile("hdfs://172.2.0.147:9000/user/hadoop/KRTable/part-m-00001").collect()
reviews2 = sc.textFile("hdfs://172.2.0.147:9000/user/hadoop/KRTable/part-m-00002").collect()
reviews3 = sc.textFile("hdfs://172.2.0.147:9000/user/hadoop/KRTable/part-m-00003").collect()

reviews_list_list = [reviews0, reviews1, reviews2, reviews3]

for table in reviews_list_list:
    for row in table:
        row_list = row.split("\t")
        if "B000F83SZQ" in row_list:
            print(row)

print(row_list) # Prints out last row_list


row = Row("id", "asin", "helpful", "overall", "reviewText", "reviewTime", "reviewerID", "reviewerName", "summary", "unixReviewTime")
#print(reviews0.map(row).take(5))



#Sample review
#review_eg = reviews0[0].split("\t")[4]
#print(review_eg)
#print(len(review_eg))
#print(reviews1[1].split("\t")[4])





#asindb = reviews1.select('asin','reviewText')
#asindb_len = asindb.withColumn('reviewLength', fns.length('reviewText'))


#reviews2 = spark.read.csv("hdfs://172.2.0.147:9000/user/hadoop/KRTable/part-m-00001", header=True)

