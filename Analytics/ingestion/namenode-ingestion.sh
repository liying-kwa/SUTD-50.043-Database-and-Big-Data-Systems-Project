#!/bin/bash


# Wait for SQL and MongoDB to be created and store their endpoints in txt files
python3 ./mysqlpython.py
python3 ./pymongocode.py

# Export IP address for SQL server and MongoDB server
export SQL_HOSTNAME=`cat sql-hostname.txt`
export MONGODB_HOSTNAME=`cat mongodb-hostname.txt`

# Ingest data from MySQL into HDFS
/opt/sqoop-1.4.7/bin/sqoop import-all-tables --connect jdbc:mysql://${SQL_HOSTNAME}/mydb?useSSL=false --username useralldb20 --password passworddb20 --fields-terminated-by "\t" --as-parquetfile -m1

# Ingest data from MongoDB into HDFS
python3 ./ingestmongo.py ${MONGODB_HOSTNAME}

# Hopefully don't need this here
#export PYSPARK_PYTHON=/usr/bin/python3.6
