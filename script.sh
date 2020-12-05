#!/bin/bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update
sudo apt-get install terraform

sudo apt install python3-pip -y
sudo pip3 install pyrebase
sudo pip3 install --upgrade google-auth-oauthlib

sudo apt install unzip

wget -c https://jinghanbucket1997.s3-ap-southeast-1.amazonaws.com/iac.zip -O iac.zip

unzip iac.zip
rm iac.zip

echo "All installations and downloads done!"