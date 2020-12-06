#!/bin/bash


# Setup IP addresses
export NAMENODE_IP=`cat ../namenode_ip.txt`

# Clean up HDFS
ssh -i ../kp.pem ubuntu@${NAMENODE_IP} "sudo -u hadoop sh -c '/opt/hadoop-3.3.0/bin/hdfs dfs -rm -r /user/hadoop/KRTable'"
ssh -i ../kp.pem ubuntu@${NAMENODE_IP} "sudo -u hadoop sh -c '/opt/hadoop-3.3.0/bin/hdfs dfs -rm -r /user/hadoop/kindle_metaData'"

# Re-ingest data
ssh -i ../kp.pem ubuntu@${NAMENODE_IP} "sudo -u hadoop sh -c 'bash ./namenode-ingestion.sh'"