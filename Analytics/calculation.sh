#!/bin/bash


# Setup IP addresses
export NAMENODE_IP=`cat namenode_ip.txt`
export DATANODE_IP_ARR=(`cat datanode_ip.txt | tr "\n" " "`)
export n=${#DATANODE_IP_ARR[@]}
export NAMENODE_IP_PRIV=`cat namenode_ip_priv.txt`
export DATANODE_IP_ARR_PRIV=(`cat datanode_ip_priv.txt | tr "\n" " "`)

# Move to the right folder and calculate
cd ./calculation/
scp -i ../kp.pem ./namenode-calculation.sh ./pearson.py ./tfidf.py ubuntu@${NAMENODE_IP}:~/
ssh -i ../kp.pem ubuntu@${NAMENODE_IP} "sudo -u hadoop sh -c 'bash ./namenode-calculation.sh'"


echo "END OF CALCULATION"