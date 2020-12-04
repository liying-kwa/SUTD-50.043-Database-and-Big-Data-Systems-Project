#!/bin/bash


# Setup IP addresses
export NAMENODE_IP=`cat namenode_ip.txt`
export DATANODE_IP_ARR=(`cat datanode_ip.txt | tr "\n" " "`)
export n=${#DATANODE_IP_ARR[@]}
export NAMENODE_IP_PRIV=`cat namenode_ip_priv.txt`
export DATANODE_IP_ARR_PRIV=(`cat datanode_ip_priv.txt | tr "\n" " "`)
cd ./spark-setup

echo "[spark-setup.sh] SPARK SETUP PART 1"
# Part 1 -- Login, download, extract and configure spark-env.sh
scp -i ../kp.pem -o StrictHostKeyChecking=no ./part1-setup.sh ubuntu@${NAMENODE_IP}:~/
ssh -i ../kp.pem ubuntu@${NAMENODE_IP} "sudo -u hadoop sh -c 'bash ./part1-setup.sh'"

echo "[spark-setup.sh] SPARK SETUP PART 2"
# Part 2 -- Installation

# For Data Nodes
for DATANODE_IP in "${DATANODE_IP_ARR[@]}"
do
    scp -i ../kp.pem ./part2-datanode-setup.sh ubuntu@${DATANODE_IP}:~/
    ssh -i ../kp.pem ubuntu@${DATANODE_IP} "sudo -u hadoop sh -c 'bash ./part2-datanode-setup.sh'"
done

# For Name Node
scp -i ../kp.pem -o StrictHostKeyChecking=no ./part2-namenode-setup.sh ubuntu@${NAMENODE_IP}:~/
ssh -i ../kp.pem ubuntu@${NAMENODE_IP} "sudo -u hadoop sh -c 'bash ./part2-namenode-setup.sh'"


# Part 3 -- Testing

# Start the spark cluster
echo "[spark-setup.sh] SPARK SETUP PART 3"
ssh -i ../kp.pem ubuntu@${NAMENODE_IP} "sudo -u hadoop sh -c '/opt/spark-3.0.1-bin-hadoop3.2/sbin/start-all.sh'"

# Check that the appropriate java processes are running on each node
echo "Namenode Jps:"
ssh -i ../kp.pem ubuntu@${NAMENODE_IP} "sudo -u hadoop sh -c 'jps'"

for DATANODE_IP in "${DATANODE_IP_ARR[@]}"
do
    echo "Datanode: ${DATANODE_IP} Jps"
    ssh -i ../kp.pem ubuntu@${DATANODE_IP} "sudo -u hadoop sh -c 'jps'"
done


echo "END OF SPARK SETUP"