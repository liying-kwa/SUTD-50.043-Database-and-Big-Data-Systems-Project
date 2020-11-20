#!/bin/bash

python3 get_number_of_nodes.py
terraform init
terraform apply -auto-approve