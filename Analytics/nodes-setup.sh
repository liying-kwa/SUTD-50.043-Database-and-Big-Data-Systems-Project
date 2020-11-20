#!/bin/bash


# Create nodes using terraform
cd ./terra/
bash ./install.sh
bash ./create.sh
terraform output NameNode_ip > namenode_ip.txt
echo `terraform output DataNode_ip` | tr "," "\n" > datanode_ip.txt

# Copy keys and IP addresses to current directory
cp ./kp.pem ../
cp ./namenode_ip.txt ../
cp ./datanode_ip.txt ../
cd ../
