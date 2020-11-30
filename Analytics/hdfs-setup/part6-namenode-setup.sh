#!/bin/bash


# Move hadoop library
cd ~/download/
sudo mv hadoop-3.3.0 /opt/

# Create hdfs storage folder
sudo mkdir -p /mnt/hadoop/namenode/hadoop-${USER}
sudo chown -R hadoop:hadoop /mnt/hadoop/namenode

# Format hdfs
echo 'Y' | /opt/hadoop-3.3.0/bin/hdfs namenode -format