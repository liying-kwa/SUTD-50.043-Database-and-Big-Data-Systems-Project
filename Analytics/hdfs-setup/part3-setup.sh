#!/bin/bash


# Setup java compiler and runtime system
sudo apt-get update
echo "Sleeping for 10 seconds..."
sleep 10
sudo apt-get install -y openjdk-8-jdk
javac -version