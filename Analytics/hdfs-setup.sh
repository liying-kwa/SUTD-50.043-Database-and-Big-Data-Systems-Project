#!/bin/bash


# Setup IP addresses
export NAMENODE_IP=`cat namenode_ip.txt`
export DATANODE_IP_ARR=(`cat datanode_ip.txt | tr "\n" " "`)
export n=${#DATANODE_IP_ARR[@]}


# PART 1: Setup hostnames, Setup sudoers, Change Swappiness
echo "[hdfs-setup.sh] HDFS SETUP PART 1"

# Part 1 -- Write hosts.txt file for editing /etc/hosts
cd ./hdfs-setup
touch hosts.txt
echo -e "${NAMENODE_IP}\tcom.analytics.namenode" >> ./hosts.txt
for i in "${!DATANODE_IP_ARR[@]}"
do
	echo -e "${DATANODE_IP_ARR[$i]}\tcom.analytics.datanode$((i + 1))" >> ./hosts.txt
done


# Part 1 -- Name Node
scp -i ../kp.pem -o StrictHostKeyChecking=no ./part1-setup.sh ./hosts.txt ubuntu@${NAMENODE_IP}:~/
ssh -i ../kp.pem -o "StrictHostKeyChecking no" ubuntu@${NAMENODE_IP} "bash ./part1-setup.sh"

# Part 1 -- Data Nodes
for DATANODE_IP in "${DATANODE_IP_ARR[@]}"
do
    scp -i ../kp.pem -o StrictHostKeyChecking=no ./part1-setup.sh ./hosts.txt ubuntu@${DATANODE_IP}:~/
    ssh -i ../kp.pem -o "StrictHostKeyChecking no" ubuntu@${DATANODE_IP} "bash ./part1-setup.sh"
done


# PART 2: Setup SSH Keys for name node to data nodes
echo "[hdfs-setup.sh] HDFS SETUP PART 2"

# Part 2 -- Generate key pair in name node
scp -i ../kp.pem ./part2-namenode-setup.sh ubuntu@${NAMENODE_IP}:~/
ssh -i ../kp.pem -o "StrictHostKeyChecking no" ubuntu@${NAMENODE_IP} "sudo -u hadoop sh -c 'bash ./part2-namenode-setup.sh'"

# Part 2 -- Copy the public key from the name node to worker nodes
for DATANODE_IP in "${DATANODE_IP_ARR[@]}"
do
    ssh ubuntu@${NAMENODE_IP} -i ../kp.pem "sudo cat /home/hadoop/.ssh/id_rsa.pub" \
    | ssh ubuntu@${DATANODE_IP} -i ../kp.pem "sudo cat - | sudo tee -a /home/hadoop/.ssh/authorized_keys"
done


# PART 3: Setup Java
echo "[hdfs-setup.sh] HDFS SETUP PART 3"

# Part 3 -- Name Node
scp -i ../kp.pem ./part3-setup.sh ubuntu@${NAMENODE_IP}:~/
ssh -i ../kp.pem ubuntu@${NAMENODE_IP} "bash ./part3-setup.sh"

# Part 3 -- Data Nodes
for DATANODE_IP in "${DATANODE_IP_ARR[@]}"
do
    scp -i ../kp.pem ./part3-setup.sh ubuntu@${DATANODE_IP}:~/
    ssh -i ../kp.pem ubuntu@${DATANODE_IP} "bash ./part3-setup.sh"
done

