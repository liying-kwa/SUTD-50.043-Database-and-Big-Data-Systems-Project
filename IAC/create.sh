#!/bin/bash
terraform init
terraform apply -auto-approve
#terraform import aws_key_pair.deployer kp.pem