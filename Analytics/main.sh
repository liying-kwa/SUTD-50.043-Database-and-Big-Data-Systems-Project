#!/bin/bash


# CHANGE CREDENTIALS HERE
export AWS_ACCESS_KEY_ID=ASIATPSO3B2H6UHIKLFC
export AWS_SECRET_ACCESS_KEY=UyeeWO2+/x1Mt/hAXwCoPh6HGzVSaSd6M9jvgHbF
export AWS_SESSION_TOKEN=FwoGZXIvYXdzEA0aDOuBuqRJjGrJ0FGn6SLMAf9g4E0fA+NuM3RIrvtSlj4RhEvlb7TYlNFyJsrpWiMFDIGQmIT0uW+rq8sTZNMXz5iqP3yrHUkHpFxQPvrzN4Cv8y0n3WbzwksNIY3R0XheO1ngdwD8HM+xFax6c5iEdBGvwrdJWvzwn1/4L0F//I8LSWEq8DJcbZP3Az5t1SxkcE6pA/NuuPOUrhUcWpqofAii6V693e5cnrk4pX7Z3iMVWFoRMEhHF1kep9/FiAlYQ1/pymsCi2/71XI1ilw3M4g35Hlqn5ky7PyxbSj63N79BTItx4BE8+3t222sNV26lE3s+Og2K/7uZVqAr7hX1QIgMuBs2J8Dbmbg4jAwEG0G

# Install AWS CLI and set up AWS Educate Credentials
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip
unzip awscliv2.zip && rm awscliv2.zip
sudo ./aws/install && rm -rf aws
aws --version
echo -e "${AWS_ACCESS_KEY_ID}\n${AWS_SECRET_ACCESS_KEY}\nus-east-1\njson\n" | sudo aws configure

# Execute scripts
echo "[main.sh] SETTING UP NODES..."
bash ./nodes-setup.sh
echo "[main.sh] SETTING UP HDFS"
bash ./hdfs-setup.sh
echo "[main.sh] SETTING UP SPARK"
bash ./spark-setup.sh