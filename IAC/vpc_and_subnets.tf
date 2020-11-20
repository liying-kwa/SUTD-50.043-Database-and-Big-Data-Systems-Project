/*

This file contains vpc, subnets and their associations. Eg. Igw, route tables, security group etc

*/

resource "aws_vpc" "main" {
    cidr_block = var.base_cidr_block
	enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "main"
    }
}


resource "aws_vpc_ipv4_cidr_block_association" "public_cidr" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "172.2.0.0/16"
}


resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.main.id}"
tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "route-table" {
  vpc_id = "${aws_vpc.main.id}"
route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
tags = {
    Name = "route-table"
  }
}



resource "aws_route_table_association" "subnet-association" {
  subnet_id      = "${aws_subnet.WebAppPublicSubnet.id}"
  route_table_id = "${aws_route_table.route-table.id}"
}

resource "aws_main_route_table_association" "a" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_route_table.route-table.id
}







resource "aws_subnet" "WebAppPublicSubnet" {
    vpc_id = "${aws_vpc_ipv4_cidr_block_association.public_cidr.vpc_id}"
	availability_zone = "ap-southeast-1a"
	#availability_zone = "us-east-1a"
    cidr_block = "172.2.0.0/24"
	
	tags = {
        Name = "WebAppPublicSubnet"
    }
}

resource "aws_subnet" "MySqlPrivateSubnet" {
    vpc_id = "${aws_vpc.main.id}"
	availability_zone = "ap-southeast-1b"
	#availability_zone = "us-east-1b"
    cidr_block = "10.1.0.0/24"
	
	tags = {
        Name = "MySqlPrivateSubnet"
    }
}

resource "aws_subnet" "MongoDBLogsPrivateSubnet" {
    vpc_id = "${aws_vpc.main.id}"
	availability_zone = "ap-southeast-1c"
	#availability_zone = "us-east-1c"
    cidr_block = "10.1.1.0/24"
	
	tags = {
        Name = "MongoDBLogsPrivateSubnet"
    }
}

resource "aws_subnet" "MongoDBMetadataPrivateSubnet" {
    vpc_id = "${aws_vpc.main.id}"
	availability_zone = "ap-southeast-1a"
	#availability_zone = "us-east-1d"
    cidr_block = "10.1.2.0/24"
	
	tags = {
        Name = "MongoDBMetadataPrivateSubnet"
    }
}


resource "aws_security_group" "main_security_group" {
    name = "main_security_group"
	vpc_id = "${aws_vpc.main.id}"

    ingress {
        protocol = "tcp"
        from_port = 80
        to_port = 80
        cidr_blocks = ["0.0.0.0/0"]
    }
	
    ingress {
        protocol = "tcp"
        from_port = 22
        to_port = 22
        cidr_blocks = ["0.0.0.0/0"]
    }
	
	ingress {
        protocol = "tcp"
        from_port = 3306
        to_port = 3306
        cidr_blocks = ["0.0.0.0/0"]
    }
	
	#mongodb
	ingress {
        protocol = "tcp"
        from_port = 27017
        to_port = 27017
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

