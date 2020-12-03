variable "region" {
	#default = "ap-southeast-1"
	default = "us-east-1"
}

variable "base_cidr_block" {
    description = "A /16 CIDR range definition that VPC will use"
    default = "10.1.0.0/16"
}

variable "ec2_instance_ami" {
    description = "Ubuntu"
	
	#for ap-southeast-1
    #default = "ami-093da183b859d5a4b"
	
	#us-east-1
	default = "ami-0885b1f6bd170450c" #20.04

}

variable "ec2_instance_type" {
	description = "ec2_instance_type, change to better ones for more speed"
    default = "t2.medium"
}
