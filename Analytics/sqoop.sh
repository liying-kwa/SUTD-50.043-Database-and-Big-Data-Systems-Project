#!/bin/bash

# To be run on namenode
echo "START OF SQOOP SETUP"

echo "SETUP IP ADDRESSES"
export NAMENODE_IP=`cat namenode_ip.txt`
export DATANODE_IP_ARR=(`cat datanode_ip.txt | tr "\n" " "`)
export n=${#DATANODE_IP_ARR[@]}
export NAMENODE_IP_PRIV=`cat namenode_ip_priv.txt`
export DATANODE_IP_ARR_PRIV=(`cat datanode_ip_priv.txt | tr "\n" " "`)

cd ./sqoop-setup


echo "[sqoop-setup.sh] SQOOP SETUP PART 1"
# Part 1 -- SETUP SQOOP
scp -i ../kp.pem -o StrictHostKeyChecking=no ./part1-setup.sh ../hdfs-setup/hosts.txt ./pymongotest.py ubuntu@${NAMENODE_IP}:~/
ssh -i ../kp.pem ubuntu@${NAMENODE_IP} "sudo -u hadoop sh -c 'bash ./part1-setup.sh'"

echo "END OF SQOOP SETUP"