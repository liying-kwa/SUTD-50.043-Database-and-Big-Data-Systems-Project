#!/bin/bash


# Setup IP addresses
export NAMENODE_IP=`cat ../namenode_ip.txt`

# Calculate Pearson correlation and TF-IDF
ssh -i ../kp.pem ubuntu@${NAMENODE_IP} "sudo -u hadoop sh -c 'bash ./namenode-calculation.sh'"