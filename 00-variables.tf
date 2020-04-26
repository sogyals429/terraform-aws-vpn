data "aws_availability_zones" "available" {}

variable "vpc_cidr" {}
variable "aws_subnets" {}
variable "my_ip" {type = string}

data "aws_ami" "open-vpn-ami" {
  most_recent = true
  owners = ["aws-marketplace"]

  filter {
	name   = "image-id"
	values = ["ami-0d8ba0e9e6b6d18b7"]
  }

  filter {
	name = "virtualization-type"
	values = ["hvm"]
  }

}