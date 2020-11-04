/*

This file contains only ec2 instances

*/



resource "aws_instance" "WebApp" {

  ami           = var.ec2_instance_ami
  instance_type = var.ec2_instance_type
  subnet_id     = aws_subnet.WebAppPublicSubnet.id
  key_name = "${aws_key_pair.deployer.id}"
  vpc_security_group_ids = ["${aws_security_group.main_security_group.id}"]
  associate_public_ip_address = true
  
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "WebApp"
  }
  
  
  user_data = <<EOF
#!/bin/sh
cd home
cd ubuntu
touch fff.csv
mkdir adir
cd adir
touch hihi.txt
mkdir hehe
EOF
}

resource "aws_instance" "Server_MySql" {

  ami           = var.ec2_instance_ami
  instance_type = var.ec2_instance_type
  subnet_id     = aws_subnet.MySqlPrivateSubnet.id
  key_name = "${aws_key_pair.deployer.id}"
  vpc_security_group_ids = ["${aws_security_group.main_security_group.id}"]
  associate_public_ip_address = true
  
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "Server_MySql"
  }
  
  user_data = <<EOF
#!/bin/sh

start=`date +%s`

cd home
cd ubuntu
sudo apt-get update
sudo apt update
sudo apt install python3-pip -y
sudo apt-get install mysql-server -y
sudo apt install unzip

wget -c https://istd50043.s3-ap-southeast-1.amazonaws.com/kindle-reviews.zip -O kindle-reviews.zip
unzip kindle-reviews.zip
rm -rf kindle_reviews.json
rm -rf *.zip

sudo mysql << SQLEOFa
CREATE DATABASE mydb;
USE mydb;
CREATE TABLE KRTable (id INT NOT NULL AUTO_INCREMENT,asin VARCHAR(255) NOT NULL,helpful VARCHAR(255) NOT NULL,overall INT NOT NULL,reviewText VARCHAR(1000) NOT NULL,reviewTime VARCHAR(255) NOT NULL,reviewerID VARCHAR(255) NOT NULL,reviewerName VARCHAR(255) NOT NULL,summary VARCHAR(255) NOT NULL,unixReviewTime INT NOT NULL,PRIMARY KEY (id));
SET GLOBAL local_infile=1;
exit
SQLEOFa

sleep 5

sudo mysql << SQLEOFb
USE mydb;
CREATE USER 'user'@'localhost' IDENTIFIED BY 'password';
CREATE USER 'userall'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON mydb.* to user@localhost with GRANT OPTION;
GRANT ALL PRIVILEGES ON mydb.* to userall@'%' with GRANT OPTION;
FLUSH PRIVILEGES;
EXIT
SQLEOFb

sudo mysql --local-infile=1 << SQLEOFc
USE mydb;
LOAD DATA LOCAL INFILE '/home/ubuntu/kindle_reviews.csv' into table KRTable FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
EXIT
SQLEOFc

sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
sudo systemctl restart mysql

echo "import pyrebase" >> database_status.py
echo "config = {
  \"apiKey\": \"AIzaSyDl_6GZJ-JsdcwVSKDW02qbfIueg04sY0Y\",
  \"authDomain\": \"dbproject-f258b.firebaseapp.com\",
  \"databaseURL\": \"https://dbproject-f258b.firebaseio.com/\",
  \"storageBucket\": \"dbproject-f258b\"
}" >> database_status.py
echo "firebase = pyrebase.initialize_app(config)" >> database_status.py
echo "db = firebase.database()" >> database_status.py
echo "data = {'created':'yes'}" >> database_status.py
echo "db.child(\"my_sql\").update(data)" >> database_status.py
pip3 install pyrebase
python3 database_status.py

end=`date +%s`
echo Execution time was `expr $end - $start` seconds. >> timetaken.txt

EOF
}

resource "aws_instance" "MongoDBLogs" {

  ami           = var.ec2_instance_ami
  instance_type = var.ec2_instance_type
  subnet_id     = aws_subnet.MongoDBLogsPrivateSubnet.id
  key_name = "${aws_key_pair.deployer.id}"
  vpc_security_group_ids = ["${aws_security_group.main_security_group.id}"]
  associate_public_ip_address = true
  
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "MongoDBLogs"
  }
  
  user_data = <<EOF
#!/bin/sh

start=`date +%s`

cd home
cd ubuntu
curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list

sudo apt update
sudo apt install python3-pip -y
sudo apt install mongodb-org -y
sudo systemctl start mongod.service
sudo systemctl enable mongod

echo "import pyrebase" >> database_status.py
echo "config = {
  \"apiKey\": \"AIzaSyDl_6GZJ-JsdcwVSKDW02qbfIueg04sY0Y\",
  \"authDomain\": \"dbproject-f258b.firebaseapp.com\",
  \"databaseURL\": \"https://dbproject-f258b.firebaseio.com/\",
  \"storageBucket\": \"dbproject-f258b\"
}" >> database_status.py
echo "firebase = pyrebase.initialize_app(config)" >> database_status.py
echo "db = firebase.database()" >> database_status.py
echo "data = {'created':'yes'}" >> database_status.py
echo "db.child(\"logs\").update(data)" >> database_status.py
pip3 install pyrebase
python3 database_status.py


end=`date +%s`
echo Execution time was `expr $end - $start` seconds. >> timetaken.txt

EOF
}

resource "aws_instance" "MongoDBMetadata" {

  ami           = var.ec2_instance_ami
  instance_type = var.ec2_instance_type
  subnet_id     = aws_subnet.MongoDBMetadataPrivateSubnet.id
  key_name = "${aws_key_pair.deployer.id}"
  vpc_security_group_ids = ["${aws_security_group.main_security_group.id}"]
  associate_public_ip_address = true
  
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "MongoDBMetadata"
  }
  
  user_data = <<EOF
#!/bin/sh

start=`date +%s`

cd home
cd ubuntu
curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list

sudo apt update
sudo apt install python3-pip -y
sudo apt install mongodb-org -y
sudo systemctl start mongod.service
sudo systemctl enable mongod

sudo apt install unzip
# Get meta data
wget -c https://jinghanbucket1997.s3-ap-southeast-1.amazonaws.com/zipfolder.zip -O zipfolder.zip
unzip zipfolder.zip
rm -rf *.zip
cd zipfolder
#wget -c https://istd50043.s3-ap-southeast-1.amazonaws.com/meta_kindle_store.zip -O meta_kindle_store.zip
#unzip meta_kindle_store.zip

# Clean up
#rm -rf *.zip

sudo mongoimport -d myMongodb --drop --legacy new_kindle_metadata.json
#sudo mongoimport -d myMongodb --drop --legacy meta_Kindle_Store.json
sudo sed -i "s,\\(^[[:blank:]]*bindIp:\\) .*,\\1 0.0.0.0," /etc/mongod.conf
sudo service mongod restart

sleep 30
mongo --eval 'db.createUser({user: "user",pwd: "password",roles: [{ role: "userAdminAnyDatabase", db:"admin"}]});' admin
sudo service mongod restart


echo "import pyrebase" >> database_status.py
echo "config = {
  \"apiKey\": \"AIzaSyDl_6GZJ-JsdcwVSKDW02qbfIueg04sY0Y\",
  \"authDomain\": \"dbproject-f258b.firebaseapp.com\",
  \"databaseURL\": \"https://dbproject-f258b.firebaseio.com/\",
  \"storageBucket\": \"dbproject-f258b\"
}" >> database_status.py
echo "firebase = pyrebase.initialize_app(config)" >> database_status.py
echo "db = firebase.database()" >> database_status.py
echo "data = {'created':'yes'}" >> database_status.py
echo "db.child(\"metadata\").update(data)" >> database_status.py
pip3 install pyrebase
python3 database_status.py


end=`date +%s`
echo Execution time was `expr $end - $start` seconds. >> timetaken.txt

EOF
}
