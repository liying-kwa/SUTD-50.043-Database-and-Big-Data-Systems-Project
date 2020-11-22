#!/bin/bash


# Generate SSH keys
sudo killall apt dkpg
sudo dpkg --configure -a
sudo apt-get install -y ssh
echo -e "\n\n\n" | ssh-keygen
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys