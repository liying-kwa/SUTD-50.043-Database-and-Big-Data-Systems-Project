/*

This file contains only ec2 instances

*/



resource "aws_instance" "Name_Node_ec2" {

  ami           = var.ec2_instance_ami
  instance_type = var.ec2_instance_type
  subnet_id     = aws_subnet.NodesSubnet.id
  key_name = "${aws_key_pair.deployer.id}"
  vpc_security_group_ids = ["${aws_security_group.main_security_group.id}"]
  associate_public_ip_address = true
  
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name  = "Name Node"
  }
  
  user_data = <<EOF
#!/bin/sh

start=`date +%s`

cd home
cd ubuntu
sudo apt-get update
sudo apt update
sudo apt install python3-pip -y

end=`date +%s`
echo Execution time was `expr $end - $start` seconds. >> timetaken.txt

EOF
}



resource "aws_instance" "Data_Nodes_ec2" {

  count = "${file("number_of_nodes.txt")}"
  ami           = var.ec2_instance_ami
  instance_type = var.ec2_instance_type
  subnet_id     = aws_subnet.NodesSubnet.id
  key_name = "${aws_key_pair.deployer.id}"
  vpc_security_group_ids = ["${aws_security_group.main_security_group.id}"]
  associate_public_ip_address = true
  
  #depends_on = [aws_internet_gateway.igw]

  tags = {
    Name  = "Data Node-${count.index + 1}"
  }
  
  user_data = <<EOF
#!/bin/sh

start=`date +%s`

cd home
cd ubuntu
sudo apt-get update
sudo apt update
sudo apt install python3-pip -y

end=`date +%s`
echo Execution time was `expr $end - $start` seconds. >> timetaken.txt

EOF
}
