#!/bin/bash


# Move hadoop library
cd /home/hadoop/download/
sudo mv hadoop-3.3.0 /opt/

# Create hdfs storage folder
sudo mkdir -p /mnt/hadoop/namenode/hadoop-${USER}
sudo chown -R hadoop:hadoop /mnt/hadoop/namenode

# Format hdfs
echo 'Y' | /opt/hadoop-3.3.0/bin/hdfs namenode -format

# Sleep for a while for datanode port to bind properly later
echo "Sleeping for 10 seconds..."
sleep 10