#!/bin/bash

echo "START OF PART 2"

# Zip up configured spark folder
tar czvf spark-3.0.1-bin-hadoop3.2.tgz spark-3.0.1-bin-hadoop3.2/

# Deploy zipped spark folder
for i in ${WORKERS};
do 
    scp -o StrictHostKeyChecking=no spark-3.0.1-bin-hadoop3.2.tgz $i:./spark-3.0.1-bin-hadoop3.2.tgz;
done

mv spark-3.0.1-bin-hadoop3.2.tgz ~/.


echo "END OF PART 2"




























