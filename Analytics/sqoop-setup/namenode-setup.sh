#!/bin/bash


# Install Sqoop
cd /home/hadoop/download/
wget https://apachemirror.sg.wuchna.com/sqoop/1.4.7/sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz
tar zxvf sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz
rm sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz

# Configure sqoop environment
cp sqoop-1.4.7.bin__hadoop-2.6.0/conf/sqoop-env-template.sh sqoop-1.4.7.bin__hadoop-2.6.0/conf/sqoop-env.sh
export HD="\/opt\/hadoop-3.3.0"
sed -i "s/#export HADOOP_COMMON_HOME=.*/export HADOOP_COMMON_HOME=${HD}/g" sqoop-1.4.7.bin__hadoop-2.6.0/conf/sqoop-env.sh
sed -i "s/#export HADOOP_MAPRED_HOME=.*/export HADOOP_MAPRED_HOME=${HD}/g" sqoop-1.4.7.bin__hadoop-2.6.0/conf/sqoop-env.sh

# For compatibility, we need to download commons-lang-2.6
wget https://repo1.maven.org/maven2/commons-lang/commons-lang/2.6/commons-lang-2.6.jar
cp commons-lang-2.6.jar sqoop-1.4.7.bin__hadoop-2.6.0/lib/

# Move to the right folder
sudo cp -rf sqoop-1.4.7.bin__hadoop-2.6.0 /opt/sqoop-1.4.7
#sudo apt install libmariadb-java
sudo apt install libmysql-java
sudo ln -snvf /usr/share/java/mysql-connector-java.jar /opt/sqoop-1.4.7/lib/mysql-connector-java.jar

# Add sqoop to PATH for convenience
export PATH=$PATH:/opt/sqoop-1.4.7/bin

#wget http://ftp.ntu.edu.tw/MySQL/Downloads/Connector-J/mysql-connector-java_8.0.22-1ubuntu20.04_all.deb
#sudo dpkg -i mysql-connector-java_8.0.22-1ubuntu20.04_all.deb
#sudo ln -snvf /usr/share/java/mysql-connector-java-8.0.22.jar /opt/sqoop-1.4.7/lib/mysql-connector-java.jar



