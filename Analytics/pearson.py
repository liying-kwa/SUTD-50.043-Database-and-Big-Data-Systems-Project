import pyspark
from pyspark.sql import SparkSession
import pyspark.sql.functions as fns

IP_ADDR = # TO ADD ""
HDFS_ADDR = # f"hdfs://ec2-{IP_ADDR}.compute-1.amazonaws.com:9000"

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
