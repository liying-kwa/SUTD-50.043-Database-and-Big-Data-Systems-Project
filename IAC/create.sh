#!/bin/bash
python init_endpoints.py

#python get_number_of_nodes.py
#python get_access_key.py
#python get_secret_key.py

terraform init
terraform apply -auto-approve
terraform output mysql_public_dns > my_sql_endpoint.txt
terraform output WebApp_elastic_ip > webapp_endpoint.txt
terraform output MongoDBMetadata_public_dns > metadata_endpoint.txt
terraform output MongoDBLogs_public_dns > logs_endpoint.txt
python push_endpoints.py