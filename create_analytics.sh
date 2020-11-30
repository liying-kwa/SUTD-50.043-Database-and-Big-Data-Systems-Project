#!/bin/bash
#python get_number_of_nodes.py
#python get_access_key.py
#python get_secret_key.py
cp access_key.txt Analytics/access_key.txt
cp secret_key.txt Analytics/secret_key.txt
cd Analytics

# Execute scripts
echo "[main.sh] SETTING UP NODES..."
cp access_key.txt terra/access_key.txt
cp secret_key.txt terra/secret_key.txt
bash ./nodes-setup.sh
echo "[main.sh] SETTING UP HDFS"
bash ./hdfs-setup.sh
echo "[main.sh] SETTING UP SPARK"
bash ./spark-setup.sh