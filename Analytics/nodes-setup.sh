#!/bin/bash


# Create nodes using terraform
cd ./terra/
bash ./install.sh
bash ./create.sh

# Store IPs of name node and data nodes in text files
terraform output NameNode_ip > namenode_ip.txt
echo `terraform output DataNode_ip` | tr "," "\n" > datanode_ip.txt
terraform output NameNode_ip_priv > namenode_ip_priv.txt
echo `terraform output DataNode_ip_priv` | tr "," "\n" > datanode_ip_priv.txt

# Copy ssh key and IP addresses to current directory
cp ./kp.pem ../
cp ./namenode_ip.txt ../
cp ./datanode_ip.txt ../
cp ./namenode_ip_priv.txt ../
cp ./datanode_ip_priv.txt ../
cd ../

# Edit permissions of ssh key to allow ssh access
chmod 0600 ./kp.pem

# Wait another few seconds for the ssh services to be ready
echo "Sleeping for 30 seconds..."
sleep 30