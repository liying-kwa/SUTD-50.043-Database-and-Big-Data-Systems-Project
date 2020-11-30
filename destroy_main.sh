#!/bin/bash
cd IAC
terraform init
terraform destroy -auto-approve
python3 close_endpoints.py