output "vpc_id" {
    value = aws_vpc.main.id
}

output "WebApp_elastic_ip" {
    value = "${aws_eip.elastic_ip.public_dns}"
}

output "mysql_public_dns" {
    value = "${aws_instance.Server_MySql.public_dns}"
}

output "MongoDBMetadata_public_dns" {
    value = "${aws_instance.MongoDBMetadata.public_dns}"
}

output "MongoDBLogs_public_dns" {
    value = "${aws_instance.MongoDBLogs.public_dns}"
}