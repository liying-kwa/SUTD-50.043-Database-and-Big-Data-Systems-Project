#!/bin/bash

# Export IP address for SQL server
export mysql_ip=18.140.53.151

# TODO CHECK INGESTION OF DATA and somehow edit mysql_ip
#/opt/sqoop-1.4.7/bin/sqoop import-all-tables --connect jdbc:mysql://${mysql_ip}/mydb?useSSL=false --username userall --password password
/opt/sqoop-1.4.7/bin/sqoop import-all-tables --connect jdbc:mysql://ec2-18-141-56-18.ap-southeast-1.compute.amazonaws.com/mydb?useSSL=false --username sqoop --password sqoop123

# TEST PYMONGO
python3 /home/ubuntu/pymongotest.py ec2-52-221-250-84.ap-southeast-1.compute.amazonaws.com 1603420304