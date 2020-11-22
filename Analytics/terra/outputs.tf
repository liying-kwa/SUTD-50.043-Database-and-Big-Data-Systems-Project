output "vpc_id" {
    value = aws_vpc.main.id
}

output "NameNode_ip" {
    value = "${aws_instance.Name_Node_ec2.public_ip}"
}


output "DataNode_ip" {
    value = "${join(",", aws_instance.Data_Nodes_ec2.*.public_ip)}"
}

output "NameNode_ip_priv" {
    value = "${aws_instance.Name_Node_ec2.private_ip}"
}

output "DataNode_ip_priv" {
    value = "${join(",", aws_instance.Data_Nodes_ec2.*.private_ip)}"
}