#!/bin/bash


# Setup IP addresses
export NAMENODE_IP=`cat namenode_ip.txt`
export DATANODE_IP_ARR=(`cat datanode_ip.txt | tr "\n" " "`)
export n=${#DATANODE_IP_ARR[@]}

# Setup the hostname
sudo sh -c 'echo -e "\n" >> /etc/hosts'
sudo sh -c 'cat ./hosts.txt >> /etc/hosts'