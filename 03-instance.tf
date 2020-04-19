resource "aws_instance" "vpn-instance" {
  ami = data.aws_ami.open-vpn-ami.id
  instance_type = "t2.small"
}