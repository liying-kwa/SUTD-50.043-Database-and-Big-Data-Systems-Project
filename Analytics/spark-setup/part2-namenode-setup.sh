#!/bin/bash


# Move spark library
cd /home/hadoop/download/
sudo mv spark-3.0.1-bin-hadoop3.2 /opt/
sudo chown -R hadoop:hadoop /opt/spark-3.0.1-bin-hadoop3.2
pip3 install pyspark