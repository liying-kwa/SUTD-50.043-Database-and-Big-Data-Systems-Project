#!/bin/bash

# To be run on namenode
echo "START OF SPARK SETUP"

echo "SETUP IP ADDRESSES"
export NAMENODE_IP=`cat namenode_ip.txt`
export DATANODE_IP_ARR=(`cat datanode_ip.txt | tr "\n" " "`)
export n=${#DATANODE_IP_ARR[@]}
export NAMENODE_IP_PRIV=`cat namenode_ip_priv.txt`
export DATANODE_IP_ARR_PRIV=(`cat datanode_ip_priv.txt | tr "\n" " "`)
cd ./spark-setup

echo "[spark-setup.sh] SPARK SETUP PART 1"
# Part 1 -- Login, download, extract and configure spark-env.sh
scp -i ../kp.pem -o StrictHostKeyChecking=no ./part1-setup.sh ../hdfs-setup/hosts.txt ubuntu@${NAMENODE_IP}:~/
ssh -i ../kp.pem ubuntu@${NAMENODE_IP} "sudo -u hadoop sh -c 'bash ./part1-setup.sh'"

echo "[spark-setup.sh] SPARK SETUP PART 2"
# Part 2 -- Deployment
scp -i ../kp.pem -o StrictHostKeyChecking=no ./part2-setup.sh ../hdfs-setup/hosts.txt ubuntu@${NAMENODE_IP}:~/
ssh -i ../kp.pem ubuntu@${NAMENODE_IP} "sudo -u hadoop sh -c 'bash ./part2-setup.sh'"

echo "[spark-setup.sh] SPARK SETUP PART 3"
# Part 3 -- Installation
# For all the nodes (including namenode and datanodes)

# For Name Node
echo "[spark-setup.sh] SPARK PART 3 FOR NAMENODE"
scp -i ../kp.pem -o StrictHostKeyChecking=no ./part3-setup.sh ../hdfs-setup/hosts.txt ubuntu@${NAMENODE_IP}:~/
ssh -i ../kp.pem ubuntu@${NAMENODE_IP} "sudo -u hadoop sh -c 'bash ./part3-setup.sh'"

# For Data Nodes
echo "[spark-setup.sh] SPARK PART 3 FOR DATANODES"
for DATANODE_IP in "${DATANODE_IP_ARR[@]}"
do
    scp -i ../kp.pem ./part3-setup.sh ../hdfs-setup/hosts.txt ubuntu@${DATANODE_IP}:~/
    ssh -i ../kp.pem ubuntu@${DATANODE_IP} "sudo -u hadoop sh -c 'bash ./part3-setup.sh'"
done


# Part 4 -- Testing
# Maybe need to stop first then start?? Not sure. Or actually if it's already started previous don't even need this.
# ssh -i ../kp.pem ubuntu@${NAMENODE_IP} "sudo -u hadoop sh -c '/opt/hadoop-3.3.0/sbin/stop-dfs.sh && /opt/hadoop-3.3.0/sbin/stop-yarn.sh'"
# ssh -i ../kp.pem ubuntu@${NAMENODE_IP} "sudo -u hadoop sh -c '/opt/hadoop-3.3.0/sbin/start-dfs.sh && /opt/hadoop-3.3.0/sbin/start-yarn.sh'"

# Start the spark cluster
echo "[spark-setup.sh] SPARK SETUP PART 4 START SPARK CLUSTER"
ssh -i ../kp.pem ubuntu@${NAMENODE_IP} "sudo -u hadoop sh -c '/opt/spark-3.0.1-bin-hadoop3.2/sbin/start-all.sh'"

# This should print out a few processes like SecondaryNameNode, NameNode, ResourceManager, Master, Jps.
echo "NAMENODE JPS"
ssh -i ../kp.pem ubuntu@${NAMENODE_IP} "sudo -u hadoop sh -c 'jps'"
echo "DATANODE JPS"
for DATANODE_IP in "${DATANODE_IP_ARR[@]}"
do
    ssh -i ../kp.pem ubuntu@${DATANODE_IP} "sudo -u hadoop sh -c 'jps'"
done


echo "END OF SPARK SETUP"