#!/bin/bash
terraform init
terraform destroy -auto-approve
python close_endpoints.py