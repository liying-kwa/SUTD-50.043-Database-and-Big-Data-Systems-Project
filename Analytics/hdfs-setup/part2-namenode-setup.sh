#!/bin/bash


# Generate SSH keys
sudo apt-get install -y ssh
echo -e "\n\n\n" | ssh-keygen
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys