#!/bin/bash


# Generate SSH keys
sudo killall apt dpkg
sudo dpkg --configure -a
sudo apt-get install -y ssh
echo -e "\n\n\n" | ssh-keygen
cat /home/hadoop/.ssh/id_rsa.pub >> /home/hadoop/.ssh/authorized_keys