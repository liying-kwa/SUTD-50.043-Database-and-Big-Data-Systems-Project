#!/bin/bash
python3 get_access_key.py
python3 get_secret_key.py
cp access_key.txt IAC/access_key.txt
cp secret_key.txt IAC/secret_key.txt
cd IAC
python3 init_endpoints.py
terraform init
terraform apply -auto-approve
terraform output mysql_public_dns > my_sql_endpoint.txt
terraform output WebApp_elastic_ip > webapp_endpoint.txt
terraform output MongoDBMetadata_public_dns > metadata_endpoint.txt
terraform output MongoDBLogs_public_dns > logs_endpoint.txt
python3 push_endpoints.py