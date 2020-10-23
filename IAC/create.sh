#!/bin/bash
python init_endpoints.py
terraform init
terraform apply -auto-approve
#terraform import aws_key_pair.deployer kp.pem
terraform output mysql_public_dns > my_sql_endpoint.txt
terraform output WebApp_public_dns > webapp_endpoint.txt
terraform output MongoDBMetadata_public_dns > metadata_endpoint.txt
terraform output MongoDBLogs_public_dns > logs_endpoint.txt
python push_endpoints.py