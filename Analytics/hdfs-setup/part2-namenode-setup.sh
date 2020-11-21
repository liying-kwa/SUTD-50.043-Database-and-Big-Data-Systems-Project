#!/bin/bash


# Generate SSH keys
sudo apt-get install -y ssh
sudo -u hadoop sh -c 'pwd'
sudo -u hadoop sh -c 'echo -e "\n\n\n" | ssh keygen'
sudo -u hadoop sh -c 'cat .ssh/id_rsa.pub >> .ssh/authorized_keys'