#!/bin/bash


# 
cd ~/
mkdir ~/download
cd ~/download
wget https://apachemirror.sg.wuchna.com/hadoop/common/hadoop-3.3.0/hadoop-3.3.0.tar.gz
tar zxvf hadoop-3.3.0.tar.gz && rm hadoop-3.3.0.tar.gz
# update the JAVA_HOME
export JH="\/usr\/lib\/jvm\/java-8-openjdk-amd64"
sed -i "s/# export JAVA_HOME=.*/export\ JAVA_HOME=${JH}/g" hadoop-3.3.0/etc/hadoop/hadoop-env.sh

MASTER=com.analytics.namenode
WORKERS=(`cat datanode_hostnames.txt | tr "\n" " "`)

# Configure core-site.xml
$ echo -e "<?xml version=\"1.0\"?>
<?xml-stylesheet type=\"text/xsl\" href=\"configuration.xsl\"?>
<\x21-- Put site-specific property overrides in this file. -->
<configuration>
  <property>
    <name>fs.defaultFS</name>
    <value>hdfs://${MASTER}:9000</value>
  </property>
</configuration>
" > hadoop-3.3.0/etc/hadoop/core-site.xml

# Configure hdfs-site.xml
$ echo -e "<?xml version=\"1.0\"?>
<?xml-stylesheet type=\"text/xsl\" href=\"configuration.xsl\"?>
<\x21-- Put site-specific property overrides in this file. -->
<configuration>
  <property>
    <name>dfs.replication</name>
    <value>3</value>
  </property>
  <property>
    <name>dfs.namenode.name.dir</name>
    <value>file:/mnt/hadoop/namenode</value>
  </property>
  <property>
    <name>dfs.datanode.data.dir</name>
    <value>file:/mnt/hadoop/datanode</value>
  </property>
</configuration>
" > hadoop-3.3.0/etc/hadoop/hdfs-site.xml

# Configure yarn-site.xml
$ echo -e "<?xml version=\"1.0\"?>
<?xml-stylesheet type=\"text/xsl\" href=\"configuration.xsl\"?>
<\x21-- Put site-specific property overrides in this file. -->
<configuration>
  <\x21-- Site specific YARN configuration properties -->
  <property>
    <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
    <description>Tell NodeManagers that there will be an auxiliary
    service called mapreduce.shuffle
    that they need to implement
    </description>
  </property>
  <property>
    <name>yarn.nodemanager.aux-services.mapreduce_shuffle.class</name>
    <value>org.apache.hadoop.mapred.ShuffleHandler</value>
    <description>A class name as a means to implement the service
    </description>
  </property>
  <property>
    <name>yarn.resourcemanager.hostname</name>
    <value>${MASTER}</value>
  </property>
</configuration>
" > hadoop-3.3.0/etc/hadoop/yarn-site.xml

# Configure mapred-site.xml
$ echo -e "<?xml version=\"1.0\"?>
<?xml-stylesheet type=\"text/xsl\" href=\"configuration.xsl\"?>
<\x21-- Put site-specific property overrides in this file. -->
<configuration>
  <\x21-- Site specific YARN configuration properties -->
  <property>
    <name>mapreduce.framework.name</name>
    <value>yarn</value>
    <description>Use yarn to tell MapReduce that it will run as a YARN application
    </description>
  </property>
  <property>
    <name>yarn.app.mapreduce.am.env</name>
    <value>HADOOP_MAPRED_HOME=/opt/hadoop-3.3.0/</value>
  </property>
  <property>
    <name>mapreduce.map.env</name>
    <value>HADOOP_MAPRED_HOME=/opt/hadoop-3.3.0/</value>
  </property>
  <property>
    <name>mapreduce.reduce.env</name>
    <value>HADOOP_MAPRED_HOME=/opt/hadoop-3.3.0/</value>
  </property>
</configuration>
" > hadoop-3.3.0/etc/hadoop/mapred-site.xml

# Edit workers file
rm hadoop-3.3.0/etc/hadoop/workers
for ip in ${WORKERS}; do echo -e "${ip}" >> hadoop-3.3.0/etc/hadoop/workers ; done


