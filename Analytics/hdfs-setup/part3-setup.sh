#!/bin/bash


# Setup java compiler and runtime system
sudo apt-get update
echo "Sleeping for 5 seconds..."
sleep(5)
sudo apt-get install -y openjdk-8-jdk
javac -version