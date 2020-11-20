provider "aws" {
  #profile = "default"
  region  = var.region
  access_key = "${file("access_key.txt")}"
  secret_key = "${file("secret_key.txt")}"
}


resource "aws_key_pair" "deployer" {
  key_name   = "kp"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCCxJqlQE1v/PMhXSP8TgP/K0jGW6xKR9ea/6ipl5+IvXL5rfLD1k4XYnYoiDc7rIuQILOYH0UyM4SxdUXYsBh8hQkefLOB9AgyHTywyXiU+wqNdC623MRJLYVn1eWMVHOiUZPi63Ltw9zh12YnDjBOUCi1AEXmcCNzC2sUEN37LGqk2VPHzOC+KdPbJMyGVB30bCVXc3XzxNNb+Y/DgYkfcX9Fwp/Uj0+ZouCmOFVuk7EbqE7LNPpp5/xt4JbF/ouDR+Tymci6atC+nDm2fOjqk8FWsHvISTy9rQLAi+hhE78Jb1roHr0lT2CkApkYF1cURgDfeiowYNNYDNoEBwZ5"
}

resource "aws_eip" "elastic_ip" {
  instance = "${aws_instance.WebApp.id}"
  vpc      = true
  depends_on = ["aws_internet_gateway.igw"]
}





