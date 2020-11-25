#!/bin/bash

echo "START OF PART 2"

# Zip up configured spark folder
tar czvf spark-3.0.1-bin-hadoop3.2.tgz spark-3.0.1-bin-hadoop3.2/


WORKERS=`cat ~/datanode_hostnames.txt | tr "\n" " "`

echo "Finished zipping, going to deploy but sleep first"
sleep 15

# Deploy zipped spark folder
for i in ${WORKERS};
do 
    scp -o StrictHostKeyChecking=no spark-3.0.1-bin-hadoop3.2.tgz $i:~/.;
done

mv spark-3.0.1-bin-hadoop3.2.tgz ~/.

echo "Another sleep here to check if scp worked"
sleep 15


echo "END OF PART 2"




























