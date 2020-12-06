#!/bin/bash


# Export SPARK_HOME again because buggy
export PYSPARK_PYTHON=/usr/bin/python3.6

# Carry out calculations
echo "[namenode-calculation.sh] CALCULATING PEARSON CORRELATION"
python3 ./pearson.py
echo "[namenode-calculation.sh] CALCULATING TF-IDF"
python3 ./tfidf.py