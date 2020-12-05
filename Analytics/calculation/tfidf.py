from pyspark.sql import SparkSession
import pyspark.sql.functions as fns
from pyspark.ml.feature import IDF, Tokenizer, CountVectorizer


# Functions to map the index of word to actual word cause CountVectorizer gives index
def map_to_word1(row, vocab):
    d = {}
    array = row.toArray()
    for i in range(len(row)):
        # if it is 0 -> ignore, else change the key to corresponding word
        if (array[i] != 0):
            tfidf = array[i]
            word = vocab[i]
            d[word] = tfidf
    return str(d)

def map_to_word(vocab):
    return fns.udf(lambda row: map_to_word1(row, vocab))


# Main

# Read MySQL reviews from HDFS as DataFrame
spark = SparkSession.builder.master("com.analytics.namenode").config("spark.master", "local").getOrCreate()
reviews = spark.read.parquet("hdfs://com.analytics.namenode:9000/user/hadoop/KRTable/")

# Drop rows with null values in reviewText
reviews.na.drop(subset=["reviewText"])

# Tokenize reviewText and output to words
tokenizer = Tokenizer(inputCol="reviewText", outputCol="words")
wordsData = tokenizer.transform(reviews)

# use CountVectorizer to get term frequency vectors
cv = CountVectorizer(inputCol="words", outputCol="rawFeatures", vocabSize=20)
model = cv.fit(wordsData)
featurizedData = model.transform(wordsData)

vocab = model.vocabulary

# Compute the IDF vector and second to scale the term frequencies by IDF
idf = IDF(inputCol="rawFeatures", outputCol="features")
idfModel = idf.fit(featurizedData)
rescaledData = idfModel.transform(featurizedData)

# Apply udf to convert index back to word
df = rescaledData.withColumn("tfidf", map_to_word(vocab)(rescaledData.features))

output = df.select("id", "tfidf")
output.show(10, truncate=False)