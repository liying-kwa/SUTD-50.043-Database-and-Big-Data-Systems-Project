#!/bin/bash

echo "START OF PART 1"

# Log into user hadoop (Check with LY whether necessary/correct)
# sudo su hadoop 


cp ./datanode_hostnames.txt ~/
cd ~/

# Download & Extract Spark
mkdir ~/download
cd ~/download/
wget https://apachemirror.sg.wuchna.com/spark/spark-3.0.1/spark-3.0.1-bin-hadoop3.2.tgz
tar zxvf spark-3.0.1-bin-hadoop3.2.tgz

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


# Configure slaves/datanodes
# Ask LY for halp
# Making use of hdfs setup PART 4: the datanode_hostnames.txt. Assuming it's line by line
# Making an empty env var WORKERS first, (Do i need export??)
# Read from datanode_hostnames.txt and adds line by line to the WORKERS env var
WORKERS=`cat ~/datanode_hostnames.txt | tr "\n" " "`




for ip in ${WORKERS};
do
    echo "{$ip} Names For testing (GOOD)"
    echo -e "${ip}" >> spark-3.0.1-bin-hadoop3.2/conf/slaves;
done



echo "END OF PART 1"
























