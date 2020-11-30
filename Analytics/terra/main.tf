provider "aws" {
  #profile = "default"
  region  = var.region
  access_key = "${file("access_key.txt")}"
  secret_key = "${file("secret_key.txt")}"
}


resource "aws_key_pair" "deployer" {
  key_name   = "kp"
  #public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCX9VOAGxfFuL3umimNxTXlR5d2KkvqWt7NdIgj/7prC9zRa+V3DYviyz4K4XXUB+X4+0DSn/oRWbbVdL/Lt+eoem0z1CI6qzHA7JTYPTI3i3Sgu4lVpR0nAWuwgLoyE7seLvncIEINBI9Hl0V6bOj7pTFAnxJTV5u0vtM9ZcXIzvAgcgxsp7hoJjNPVpxJ/5M7/WkR165EDRngiNq2gPMn3io5EUurno1q/FwfxDmysR6+peKCYgdSZWDMrzFEXFV9PceS4nB3mb4ezb5wJTdOT/hdTX9LSyNFeLlmsRLPIZ51NQ529tW9E5Z6c9k2p0cPC74giPcK8EaA4qCc5OG7"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCCxJqlQE1v/PMhXSP8TgP/K0jGW6xKR9ea/6ipl5+IvXL5rfLD1k4XYnYoiDc7rIuQILOYH0UyM4SxdUXYsBh8hQkefLOB9AgyHTywyXiU+wqNdC623MRJLYVn1eWMVHOiUZPi63Ltw9zh12YnDjBOUCi1AEXmcCNzC2sUEN37LGqk2VPHzOC+KdPbJMyGVB30bCVXc3XzxNNb+Y/DgYkfcX9Fwp/Uj0+ZouCmOFVuk7EbqE7LNPpp5/xt4JbF/ouDR+Tymci6atC+nDm2fOjqk8FWsHvISTy9rQLAi+hhE78Jb1roHr0lT2CkApkYF1cURgDfeiowYNNYDNoEBwZ5"
}




