#!/bin/bash

# Install dependencies
sudo apt-get update
sudo apt-get -y install python3
sudo apt-get -y install python3-pip
sudo apt-get -y install scala git
# sudo apt-get -y default-jdk  might not be needed after hadoop installation.
wget https://downloads.apache.org/spark/spark-3.0.1/spark-3.0.1-bin-hadoop3.2.tgz
tar -xvf spark-3.0.1-bin-hadoop3.2.tgz
rm spark-3.0.1-bin-hadoop3.2.tgz
sudo mv spark-3.0.1-bin-hadoop3.2 /opt/spark

# Set environment variables for spark and python
cat <<'EOF' >> .bashrc
# Spark and Python
export SPARK_HOME=/opt/spark
export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
export PYSPARK_PYTHON=/usr/bin/python3
export PATH=$PATH:$SPARK_HOME/bin
export PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.7-src.zip:$PYTHONPATH
EOF

# Apply changes. Note: Only wef from next session
source ~/.bashrc 

# To start as master node
#/opt/spark/sbin/start-master.sh

# To start as slave node
#/opt/spark/sbin/start-slave.sh

# To use pyspark shell
#/opt/spark/bin/pyspark
