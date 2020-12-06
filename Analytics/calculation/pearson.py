import pyspark
from pyspark.sql import SparkSession
import pyspark.sql.functions as fns


# Read MongoDB Metadata from HDFS
spark = SparkSession.builder.master("com.analytics.namenode").config("spark.master", "local").getOrCreate()
df = spark.read.json("hdfs://com.analytics.namenode:9000/user/hadoop/kindle_metaData/")

# Read MySQL Data from HDFS
# DataFrame[id: int, asin: string, helpful: string, overall: int, reviewText: string, reviewTime: string, reviewerID: string, reviewerName
reviews = spark.read.parquet("hdfs://com.analytics.namenode:9000/user/hadoop/KRTable/")

asindb = reviews.select('asin','reviewText')
asindb_len = asindb.withColumn('reviewLength', fns.length('reviewText'))

# Group tgt average length by asin
asin_avglen = asindb_len.groupBy('asin').avg('reviewLength')

# Join table
table = asin_avglen.join(df.select('asin', 'price'), ['asin'])

# Return column for Pearson
table = table.agg(fns.corr('avg(reviewLength)', 'price').alias('pearson_coefficient'))
print("Final Table")
table.show()
