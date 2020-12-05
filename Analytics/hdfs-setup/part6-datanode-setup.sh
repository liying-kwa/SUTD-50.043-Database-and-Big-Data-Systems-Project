#!/bin/bash


# Move hadoop library
cd /home/hadoop/
tar zxvf hadoop-3.3.0.tgz
rm hadoop-3.3.0.tgz
sudo mv hadoop-3.3.0 /opt/

# Create hdfs storage folder
sudo mkdir -p /mnt/hadoop/datanode/
sudo chown -R hadoop:hadoop /mnt/hadoop/datanode/