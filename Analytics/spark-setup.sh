#!/bin/bash

# To be run on namenode
echo "START OF SPARK SETUP"

cd ./spark-setup


# Part 1 -- Login, download, extract and configure spark-env.sh
scp -i ../kp.pem -o StrictHostKeyChecking=no ./part1-setup.sh ./hosts.txt ubuntu@${NAMENODE_IP}:~/
ssh -i ../kp.pem -o "StrictHostKeyChecking no" ubuntu@${NAMENODE_IP} "bash ./part1-setup.sh"


# Part 2 -- Deployment
scp -i ../kp.pem -o StrictHostKeyChecking=no ./part2-setup.sh ./hosts.txt ubuntu@${NAMENODE_IP}:~/
ssh -i ../kp.pem -o "StrictHostKeyChecking no" ubuntu@${NAMENODE_IP} "bash ./part2-setup.sh"


# Part 3 -- Installation
# For all the nodes (including namenode and datanodes)

# For Name Node
scp -i ../kp.pem -o StrictHostKeyChecking=no ./part3-setup.sh ./hosts.txt ubuntu@${NAMENODE_IP}:~/
ssh -i ../kp.pem -o "StrictHostKeyChecking no" ubuntu@${NAMENODE_IP} "bash ./part3-setup.sh"

# For Data Nodes
for DATANODE_IP in "${DATANODE_IP_ARR[@]}"
do
    scp -i ../kp.pem -o StrictHostKeyChecking=no ./part3-setup.sh ./hosts.txt ubuntu@${DATANODE_IP}:~/
    ssh -i ../kp.pem -o "StrictHostKeyChecking no" ubuntu@${DATANODE_IP} "bash ./part3-setup.sh"
done


# Part 4 -- Testing
# Maybe need to stop first then start?? Not sure. Or actually if it's already started previous don't even need this.
# ssh -i ../kp.pem ubuntu@${NAMENODE_IP} "sudo -u hadoop sh -c '/opt/hadoop-3.3.0/sbin/stop-dfs.sh && /opt/hadoop-3.3.0/sbin/stop-yarn.sh'"
# ssh -i ../kp.pem ubuntu@${NAMENODE_IP} "sudo -u hadoop sh -c '/opt/hadoop-3.3.0/sbin/start-dfs.sh && /opt/hadoop-3.3.0/sbin/start-yarn.sh'"

# Start the spark cluster
ssh -i ../kp.pem ubuntu@${NAMENODE_IP} "sudo -u hadoop sh -c '/opt/spark-3.0.1-bin-hadoop3.2/sbin/start-all.sh'"
jps # This should print out a few processes like SecondaryNameNode, NameNode, ResourceManager, Master, Jps.

echo "END OF SPARK SETUP"