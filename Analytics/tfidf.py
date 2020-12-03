import pyspark
from pyspark.sql import SparkSession
import pyspark.sql.functions as fns
from pyspark.ml.feature import HashingTF, IDF, Tokenizer

#table.persist() somewhere to improve speed

IP_ADDR = # TO ADD ""
HDFS_ADDR = # f"hdfs://ec2-{IP_ADDR}.compute-1.amazonaws.com:9000"

sc = pyspark.SparkContext(f"spark://ec2-{IP_ADDR}.compute-1.amazonaws.com:7077", "Correlation")
spark = SparkSession(sc)

# Read in reviews
reviews = spark.read.csv(f"{HDFS_ADDR}/datasets/kindle_reviews.csv", header=True)

# Tokenize reviewText and output to words
tokenizer = Tokenizer(inputCol="reviewText", outputCol="words")
wordsData = tokenizer.transform(reviews)

# Hashing
hashingTF = HashingTF(inputCol="words", outputCol="rawFeatures", numFeatures=20)
featurizedData = hashingTF.transform(wordsData)

# IDF
idf = IDF(inputCol="rawFeatures", outputCol="features")
idfModel = idf.fit(featurizedData)
rescaledData = idfModel.transform(featurizedData)

rescaledData.select("label", "features").show()


spark.stop()