#!/bin/bash


# Setup java compiler and runtime system
sudo killall apt dkpg
sudo dpkg --configure -a
sudo apt-get update
sudo apt-get install -y openjdk-8-jdk
javac -version