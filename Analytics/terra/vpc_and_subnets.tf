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
  subnet_id      = "${aws_subnet.NodesSubnet.id}"
  route_table_id = "${aws_route_table.route-table.id}"
}

resource "aws_main_route_table_association" "a" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_route_table.route-table.id
}




resource "aws_subnet" "NodesSubnet" {
    vpc_id = "${aws_vpc_ipv4_cidr_block_association.public_cidr.vpc_id}"
	availability_zone = "ap-southeast-1a"
    cidr_block = "172.2.0.0/24"
	
	tags = {
        Name = "NodesSubnet"
    }
}



resource "aws_security_group" "main_security_group" {
    name = "main_security_group"
	vpc_id = "${aws_vpc.main.id}"
	
	ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

