#!/bin/bash
cd Analytics
cd terra

terraform init
terraform destroy -auto-approve

