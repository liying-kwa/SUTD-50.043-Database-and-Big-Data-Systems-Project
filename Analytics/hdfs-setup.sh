#!/bin/bash


# Setup IP addresses
export NAMENODE_IP=`cat namenode_ip.txt`
export DATANODE_IP_ARR=(`cat datanode_ip.txt | tr "\n" " "`)

export n=${#DATANODE_IP_ARR[@]}
export NAMENODE_IP_PRIV=`cat namenode_ip_priv.txt`
export DATANODE_IP_ARR_PRIV=(`cat datanode_ip_priv.txt | tr "\n" " "`)


# PART 1: Setup hostnames, Setup sudoers, Change Swappiness
echo "[hdfs-setup.sh] HDFS SETUP PART 1"

# Part 1 -- Write private ip addresses to hosts.txt file for editing /etc/hosts
cd ./hdfs-setup
touch hosts.txt
echo -e "${NAMENODE_IP_PRIV}\tcom.analytics.namenode" >> ./hosts.txt
for i in "${!DATANODE_IP_ARR_PRIV[@]}"
do
	echo -e "${DATANODE_IP_ARR_PRIV[$i]}\tcom.analytics.datanode$((i + 1))" >> ./hosts.txt
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


# PART 4: Setup Hadoop
echo "[hdfs-setup.sh] HDFS SETUP PART 4"

# Part 4 -- Write datanodes' hostnames for editing hadoop-3.3.0/etc/hadoop/workers
touch datanode_hostnames.txt
for i in "${!DATANODE_IP_ARR[@]}"
do
    echo -e "com.analytics.datanode$((i + 1))" >> ./datanode_hostnames.txt
done

# Part 4 -- In name node, download hadoop library and configure files
scp -i ../kp.pem ./part4-namenode-setup.sh ./datanode_hostnames.txt ubuntu@${NAMENODE_IP}:~/
ssh -i ../kp.pem ubuntu@${NAMENODE_IP} "sudo -u hadoop sh -c 'bash ./part4-namenode-setup.sh'"


# PART 5: Distributing the configured library
echo "[hdfs-setup.sh] HDFS SETUP PART 5"

# Part 5 -- From name node, copy hadoop library into data nodes
scp -i ../kp.pem ./part5-namenode-setup.sh ubuntu@${NAMENODE_IP}:~/
ssh -i ../kp.pem ubuntu@${NAMENODE_IP} "sudo -u hadoop sh -c 'bash ./part5-namenode-setup.sh'"


# PART 6: Installation
echo "[hdfs-setup.sh] HDFS SETUP PART 6"

# Part 6 -- Data Nodes
for DATANODE_IP in "${DATANODE_IP_ARR[@]}"
do
    scp -i ../kp.pem ./part6-datanode-setup.sh ubuntu@${DATANODE_IP}:~/
    ssh -i ../kp.pem ubuntu@${DATANODE_IP} "sudo -u hadoop sh -c 'bash ./part6-datanode-setup.sh'"
done

# Part 6 -- Name Nodes
scp -i ../kp.pem ./part6-namenode-setup.sh ubuntu@${NAMENODE_IP}:~/
ssh -i ../kp.pem ubuntu@${NAMENODE_IP} "sudo -u hadoop sh -c 'bash ./part6-namenode-setup.sh'"


# PART 7: Start Hadoop
echo "[hdfs-setup.sh] HDFS SETUP PART 7"

# Part 7 -- Start hadoop on name node
ssh -i ../kp.pem ubuntu@${NAMENODE_IP} "sudo -u hadoop sh -c '/opt/hadoop-3.3.0/sbin/start-dfs.sh && /opt/hadoop-3.3.0/sbin/start-yarn.sh'"


echo "END OF HDFS SETUP"
