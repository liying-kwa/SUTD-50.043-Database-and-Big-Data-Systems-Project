#!/bin/bash


# Create nodes using terraform
cd ./terra/
bash ./install.sh
bash ./create.sh
terraform output NameNode_ip > namenode_ip.txt
echo `terraform output DataNode_ip` | tr "," "\n" > datanode_ip.txt

# Copy ssh key and IP addresses to current directory
cp ./kp.pem ../
cp ./namenode_ip.txt ../
cp ./datanode_ip.txt ../
cd ../

# Edit permissions of ssh key to allow ssh access
chmod 0600 ./kp.pem

# Wait another few seconds for the ssh services to be ready
echo "Sleeping for 15 seconds..."
sleep 15