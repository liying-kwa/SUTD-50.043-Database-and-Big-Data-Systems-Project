#!/bin/bash


# Setup IP addresses
export NAMENODE_IP=`cat namenode_ip.txt`
export DATANODE_IP_ARR=(`cat datanode_ip.txt | tr "\n" " "`)
export n=${#DATANODE_IP_ARR[@]}

# Write hosts.txt file for editing /etc/hosts
cd ./hdfs-setup
touch hosts.txt
echo -e "${NAMENODE_IP}\tcom.analytics.namenode" >> ./hosts.txt
for i in "${!DATANODE_IP_ARR[@]}"
do
	echo -e "${DATANODE_IP_ARR[$i]}\tcom.analytics.datanode$((i + 1))" >> ./hosts.txt
done


# Setup for name node part 1
scp -i ../kp.pem -o StrictHostKeyChecking=no ./namenode-setup.sh ./hosts.txt ubuntu@${NAMENODE_IP}:~/
echo -e "bash ./namenode-setup.sh" | ssh -i ../kp.pem -o "StrictHostKeyChecking no" ubuntu@${NAMENODE_IP}

# Setup for data nodes part 1
for DATANODE_IP in "${DATANODE_IP_ARR[@]}"
do
    scp -i ../kp.pem -o StrictHostKeyChecking=no ./datanode-setup.sh ./hosts.txt ubuntu@${DATANODE_IP}:~/
    echo -e "bash ./datanode-setup.sh" | ssh -i ../kp.pem -o "StrictHostKeyChecking no" ubuntu@${DATANODE_IP}
done




