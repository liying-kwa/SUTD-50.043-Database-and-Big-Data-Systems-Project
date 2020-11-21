#!/bin/bash


# Setup the hostname
sudo sh -c 'echo -e "\n" >> /etc/hosts'
sudo sh -c 'cat ./hosts.txt >> /etc/hosts'

# Create user hadoop and grant superuser privileges
sudo adduser --system --shell /bin/bash --gecos 'User for managing of hadoop' --group --disabled-password --home /home/hadoop hadoop
sudo sh -c 'echo "hadoop ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/90-hadoop'