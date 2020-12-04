#!/bin/bash


# Download & Extract Spark
cd /home/hadoop/download/
wget https://apachemirror.sg.wuchna.com/spark/spark-3.0.1/spark-3.0.1-bin-hadoop3.2.tgz
tar zxvf spark-3.0.1-bin-hadoop3.2.tgz
rm spark-3.0.1-bin-hadoop3.2.tgz

# Configure spark-env.sh
cp spark-3.0.1-bin-hadoop3.2/conf/spark-env.sh.template \
spark-3.0.1-bin-hadoop3.2/conf/spark-env.sh

echo -e "
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export HADOOP_HOME=/opt/hadoop-3.3.0
export SPARK_HOME=/opt/spark-3.0.1-bin-hadoop3.2
export SPARK_CONF_DIR=\${SPARK_HOME}/conf
export HADOOP_CONF_DIR=\${HADOOP_HOME}/etc/hadoop
export YARN_CONF_DIR=\${HADOOP_HOME}/etc/hadoop
export SPARK_EXECUTOR_CORES=1
export SPARK_EXECUTOR_MEMORY=2G
export SPARK_DRIVER_MEMORY=1G
export PYSPARK_PYTHON=python3
" >> spark-3.0.1-bin-hadoop3.2/conf/spark-env.sh


# Edit slaves file
cp /home/hadoop/datanode_hostnames.txt spark-3.0.1-bin-hadoop3.2/conf/slaves


# Assign hostnames to vars for convenience
WORKERS=`cat /home/hadoop/datanode_hostnames.txt | tr "\n" " "`

# Compress and copy spark folder to data nodes
tar czvf spark-3.0.1-bin-hadoop3.2.tgz spark-3.0.1-bin-hadoop3.2/
for i in ${WORKERS} ; do scp -o StrictHostKeyChecking=no spark-3.0.1-bin-hadoop3.2.tgz $i:.; done
rm spark-3.0.1-bin-hadoop3.2.tgz
cd /home/hadoop
























