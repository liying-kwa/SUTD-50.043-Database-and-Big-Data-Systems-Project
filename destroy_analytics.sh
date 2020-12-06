#!/bin/bash
cd Analytics
cd terra

terraform init
terraform destroy -auto-approve

cd ../
cd hdfs-setup/
sudo rm datanode_hostnames.txt
sudo rm hosts.txt