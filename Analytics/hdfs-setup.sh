#!/bin/bash


# Setup IP addresses
export NAMENODE_IP=`cat namenode_ip.txt`
export DATANODE_IP_ARR=(`cat datanode_ip.txt | tr "\n" " "`)
export n=${#DATANODE_IP_ARR[@]}

# Setup hostname
cd ./hdfs-setup
touch hosts.txt
echo -e "${NAMENODE_IP}\tcom.analytics.namenode" >> ./hosts.txt
for i in "${!DATANODE_IP_ARR[@]}"
do
	echo -e "${DATANODE_IP_ARR[$i]}\tcom.analytics.datanode$((i + 1))" >> ./hosts.txt
done
scp -i ../kp.pem ./namenode-setup.sh ./hosts.txt ubuntu@${NAMENODE_IP}:~/
echo -e "bash ./namenode-setup.sh" | ssh -o "StrictHostKeyChecking no" ubuntu@${NAMENODE_IP} -i ./kp.pem

