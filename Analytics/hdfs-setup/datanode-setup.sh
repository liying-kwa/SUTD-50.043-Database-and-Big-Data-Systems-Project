#!/bin/bash


# Setup the hostname
sudo sh -c 'echo -e "\n" >> /etc/hosts'
sudo sh -c 'cat ./hosts.txt >> /etc/hosts'