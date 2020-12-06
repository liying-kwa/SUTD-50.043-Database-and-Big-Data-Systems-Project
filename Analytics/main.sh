#!/bin/bash

cp access_key.txt terra/access_key.txt
cp secret_key.txt terra/secret_key.txt

# Execute scripts
echo "[main.sh] SETTING UP NODES..."
bash ./nodes-setup.sh
echo "[main.sh] SETTING UP HDFS"
bash ./hdfs-setup.sh
echo "[main.sh] SETTING UP SPARK"
bash ./spark-setup.sh
echo "[main.sh] SETTING UP SQOOP"
bash ./sqoop-setup.sh
echo "[main.sh] INGESTING DATA"
bash ./ingestion.sh
echo "[main.sh] CALCULATING PEARSON AND TFIDF"
bash ./calculation.sh