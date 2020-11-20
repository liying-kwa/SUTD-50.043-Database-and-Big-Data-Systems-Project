#!/bin/bash


# Spin up EC2 instances for namenode and datanodes
NUM_NODES=4

# AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip
unzip awscliv2.zip && rm awscliv2.zip
sudo ./aws/install && rm -rf aws
aws --version
echo -e "ASIATPSO3B2HQC5UIXUS\nTyPOly8XgkMODVibHLOcG2cgWRK2wReoQKfwwkSp\nus-east-1\njson\n" | aws configure

# Boto3
sudo apt-get install -y python3-pip
sudo apt-get update
python3 -m pip install boto3
echo -e "import boto3

num_nodes = ${NUM_NODES}

# Set up Boto3 with AWS credentials
session = boto3.session.Session(aws_access_key_id='ASIATPSO3B2HRNMDQCXS', aws_secret_access_key='/Dj79+zK28AgZCb0kPG1fh0YITGoq+IYwxB4c3N8', aws_session_token='FwoGZXIvYXdzEOH//////////wEaDHUD8E3iYJVLvSYjPCLMAd+E8Wz+br+Dh7tPSYnYL/RHfw4nKC2+IJnE6gWQ/4L+3Tjd8wiMyXrM7r3J46PP5JjBENR1te7RutkMm39SkiPuxGYAEkP37gtMbGvkzJempk+irm4VvRjpp8/O/mctzq3ug44P2KeFajSUb/qxgm10XV9lWmXDpI8t2LAwUVujWHsqp5pbG6vRSEWrcDiBjBJk/b3+qgJY7B7Ea6Ymfg9ptDzY7pvMie0Eoiuko+gmhU/5qL7DuimbavRP4Sz0T7dNsQvx3vm9/ZtRYSi4gtX9BTItsiN27TfBXEc5oeg0NPxFzFP5HxB2BUTA2MKQNTi0BLz0g9QgW6i+UZa9PUBJ', region_name='us-east-1')
ec2 = session.resource('ec2')

# Create subnet
vpc = ec2.create_vpc(CidrBlock='10.0.0.0/16')
vpc.wait_until_available()
vpc.create_tags(Tags=[{'Key':'TestVPC','Value':'default_vpc'}])
with open('vpc.txt', 'w') as vpc_file:
	vpc_file.write(vpc.id)
	print(vpc.id)
subnet = ec2.create_subnet(CidrBlock = '10.0.2.0/24', VpcId= vpc.id)
with open('subnet.txt', 'w') as subnet_file:
	subnet_file.write(subnet.id)
	print(subnet.id)

# Create namenode and datanodes
instances = ec2.create_instances(
		ImageId='ami-00ddb0e5626798373',
		InstanceType='t2.xlarge',
		MinCount=num_nodes,
		MaxCount=num_nodes,
		KeyName='test_key',
		NetworkInterfaces=[
			{
				'DeviceIndex': 0,
				'AssociatePublicIpAddress': True,
				'SubnetId': subnet.id
			}
		],
)
priv_ip_addr_file = open('priv_ip_addr.txt', 'w')
pub_ip_addr_file = open('pub_ip_addr.txt', 'w')
for i in instances:
	i.wait_until_running()
	priv_ip_addr_file.write(i.private_ip_address + '\\\n')
	print(i.private_ip_address)
	pub_ip_addr_file.write(i.public_ip_address + '\\\n')
	print(i.public_ip_address)
priv_ip_addr_file.close()
pub_ip_addr_file.close()
" > hdfs-create-nodes.py
python3 hdfs-create-nodes.py

