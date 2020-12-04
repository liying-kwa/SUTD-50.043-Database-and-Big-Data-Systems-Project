#!/bin/bash


# Install pymongo
sudo pip3 install pymongo

# Export IP address for SQL server
export mysql_ip=18.140.53.151

# TODO CHECK INGESTION OF DATA and somehow edit mysql_ip
/opt/sqoop-1.4.7/bin/sqoop import-all-tables --connect jdbc:mysql://${mysql_ip}/mydb?useSSL=false --username userall --password password

# TEST PYMONGO
python3 /home/ubuntu/pymongotest.py ec2-52-221-250-84.ap-southeast-1.compute.amazonaws.com 1603420304