#!/bin/bash


# Assign hostnames to vars for convenience
WORKERS=`cat ~/datanode_hostnames.txt | tr "\n" " "`

# Compress and copy hadoop folder to data nodes
cd ~/download/
tar czvf hadoop-3.3.0.tgz hadoop-3.3.0
for h in $WORKERS ; do scp -o StrictHostKeyChecking=no hadoop-3.3.0.tgz $h:.; done
mv hadoop-3.3.0.tgz ~/
cd ~/