#!/bin/bash

# Install required software
sudo apt-get -y install ssh
sudo apt-get -y install openssh-server

# Configure SSH
echo -e "\n\n\n" | ssh-keygen -t rsa -P ""
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
echo -e "exit\n" | ssh -o "StrictHostKeyChecking no" localhost

# Download Java 8 package and check that it is installed properly
sudo apt-get update
sudo apt-get -y install openjdk-8-jdk
java -version

# Download Hadoop package and extract tar file, move to /opt, rename folder and change permissions
wget https://archive.apache.org/dist/hadoop/core/hadoop-3.2.1/hadoop-3.2.1.tar.gz
tar -xzf hadoop-3.2.1.tar.gz
mv hadoop-3.2.1 hadoop
rm hadoop-3.2.1.tar.gz

# Add Java Path to hadoop-env script, which contains env vars used to run Hadoop
echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/" >> ~/hadoop/etc/hadoop/hadoop-env.sh

# Set environment variables for Hadoop
cat <<'EOF' >> ~/.bashrc
# Hadoop
export HADOOP_HOME=~/hadoop
export HADOOP_CONF_DIR=~/hadoop/etc/hadoop
export HADOOP_MAPRED_HOME=~/hadoop
export HADOOP_COMMON_HOME=~/hadoop
export HADOOP_HDFS_HOME=~/hadoop
export YARN_HOME=~/hadoop
export PATH=$PATH:~/hadoop/bin
export PATH=$PATH:~/hadoop/sbin
EOF

# Apply changes. Note: Only wef from next session
source ~/.bashrc

# Optional: Ensure Hadoop has been properly installed
~/hadoop/bin/hadoop version

# Edit Hadoop Configuration Files (TBC for all 4 files)
cat <<'EOF' > ~/hadoop/etc/hadoop/core-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
  <property>
    <name>fs.defaultFS</name>
    <value>hdfs://localhost:9000</value>
  </property>
</configuration>
EOF
cat <<'EOF' > ~/hadoop/etc/hadoop/hdfs-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
  <property>
    <name>dfs.datanode.data.dir</name>
    <value>/tmp/hdfs/datanode</value>
  </property>
  <property>
    <name>dfs.namenode.name.dir</name>
    <value>/tmp/hdfs/namenode</value>
  </property>
  <property>
    <name>dfs.replication</name>
    <value>1</value>
  </property>
</configuration> 
EOF
cat <<'EOF' > ~/hadoop/etc/hadoop/mapred-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
  <property>
    <name>mapreduce.framework.name</name>
    <value>yarn</value>
  </property>
</configuration>
EOF
cat <<'EOF' > ~/hadoop/etc/hadoop/yarn-site.xml
<?xml version="1.0"?>
<configuration>
  <property>
    <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
  </property>
  <property>
    <name>yarn.nodemanager.auxservices.mapreduce.shuffle.class</name>  
    <value>org.apache.hadoop.mapred.ShuffleHandler</value>
  </property>
</configuration> 
EOF

# Directories given in hdfs-site must exist and be read-writable
mkdir -p /tmp/hdfs/datanode
mkdir -p /tmp/hdfs/namenode

# Format HDFS via NameNode, i.e. initialise directory specified by dfs.name.dir variable
~/hadoop/bin/hdfs namenode -format -force

# Start hdfs and yarn daemons
~/hadoop/sbin/start-dfs.sh
~/hadoop/sbin/start-yarn.sh

# Optinal: Check running Hadoop processes
jps

# Optional: Open webconsole
#localhost:9870
