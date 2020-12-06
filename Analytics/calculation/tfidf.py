from pyspark.sql import SparkSession
import pyspark.sql.functions as fns
from pyspark.ml.feature import IDF, Tokenizer, CountVectorizer

#peiyuan li ying
'''
    usage of pyspark for tfidf
'''

#map index of word to actual word
def helper(row, vocab):
    d = {}
    array = row.toArray()
    for index in range(len(row)):   
        if (array[index] != 0):
            tfidf = array[index]
            word = vocab[index]
            d[word] = tfidf
        else:
            #do nth if zero
            pass
    return str(d)

def map_to_word(vocab):
    return fns.udf(lambda row: helper(row, vocab))



#to read mysql reviews from HDFS and remove null
spark = SparkSession.builder.master("com.analytics.namenode").config("spark.master", "local").getOrCreate()
kindle_reviews = spark.read.parquet("hdfs://com.analytics.namenode:9000/user/hadoop/KRTable/")
kindle_reviews.na.drop(subset=["reviewText"])

#tokenize and output to words column
tokenizer = Tokenizer(inputCol="reviewText", outputCol="words")
wordsData = tokenizer.transform(kindle_reviews)

#CountVectorizer to get tf
cv = CountVectorizer(inputCol="words", outputCol="rawFeatures", vocabSize=20)
model = cv.fit(wordsData)
featurizedData = model.transform(wordsData)
vocab = model.vocabulary

#compute idf 
idf = IDF(inputCol="rawFeatures", outputCol="features")
idfModel = idf.fit(featurizedData)
rescaledData = idfModel.transform(featurizedData)

#convert index back to word using function declared above
data = rescaledData.withColumn("tfidf", map_to_word(vocab)(rescaledData.features))
result = data.select("id", "tfidf")

#select how many result you want to display
number_display = 10
result.show(number_display, truncate=False)