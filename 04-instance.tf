resource "aws_key_pair" "vpn-key-pair" {
  key_name = "terraform-vpn"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDJ+S7v3chljeWbhFomPHRvMpZjOg4sUXcHlWZDsRpnbZgUm7f8dtOSkcXY1UmKxd2DiDJBl1TmovqQfa6UmYGQwSooeRbwH0zrnRB5tf1dymE+MuaYmRCSg+DG1jw0Uaqsb/7LjuKoLHzAcubfIJOu5CysHmdcLElcJrD8itzcBBeS6jPj+xgN5G3RVT5zjrtEZsOCGitnQy39kNuTPzhSFyqyQyWKwoNuN64mIUWW12S1tQQVZ8l6NPEL55Fuh0YAu4JVQCJ6GYCFc04BBM4CCGTtuupJBiB9zC8XGB0puF4wqX4URlnNvMbHHNhekSHn4U+yOq6/Eq3dv1+smekWFtQ6i6TFkW3lF3djlAJhZ+4ur0TKL50KvXBIOR3CrKp1Qd6uKOEZkKvC6CZ1kRF44FdNjppxw9j57L95vIY2181K/QmdUSrvOu0xoYyWlpAnKYvmnA7gOWIx2cqdSHv2OagJcN970+LMngr+5pKCNsto3tkdaI5p/VvnpEo4AVIz+Yde8XEggIQq9zU0J/vAXRf8Ufc8IGe0M1/QSS9qKfyH92cNw4OP+HQ5Y1zNkNZM2GHMxeUYyc4pMmr9ktNU6AzqBUD6U5ATX5yLTRbKS/aOgkzzkTzgvVWUhaIfvxwTpjcTSspuILo7xURbk/7mj50kM67GpgxtB/OQMghwXQ== sogyals429@gmail.com"
  tags = merge({
	Name="terraform-vpn-keypair"
  },
  local.common_tags
  )
}
resource "aws_instance" "vpn-instance" {
  ami = data.aws_ami.open-vpn-ami.id
  instance_type = "t2.large"
  vpc_security_group_ids = [aws_security_group.vpn-instance-sg.id]
  subnet_id = aws_subnet.vpn-subnets.0.id
  key_name = aws_key_pair.vpn-key-pair.key_name
  source_dest_check = false

  user_data = "sudo apt-get update sudo apt-get upgrade"
  tags = merge({
	Name="vpn-instance"
  },
  	local.common_tags
  )

}