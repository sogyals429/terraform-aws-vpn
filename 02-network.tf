resource "aws_vpc" "vpn-vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = merge(
  {Name="vpn-vpc"},
  local.common_tags
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpn-vpc.id

  tags = merge({Name="vpn-igw"},local.common_tags)
}

resource "aws_subnet" "vpn-subnets" {
  count = length(data.aws_availability_zones.available.names)
  cidr_block = element(var.aws_subnets,count.index )
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id = aws_vpc.vpn-vpc.id
  map_public_ip_on_launch = true
  tags = merge({Name="vpn-subnet-${count.index}"},local.common_tags)
}

resource "aws_route_table" "vpn-rt" {
  vpc_id = aws_vpc.vpn-vpc.id
  tags = merge({Name="vpn-route-table"},local.common_tags)
}

resource "aws_route_table_association" "vpn-rt-assoc" {
  count = length(aws_subnet.vpn-subnets)
  route_table_id = aws_route_table.vpn-rt.id
  subnet_id = element(aws_subnet.vpn-subnets.*.id, count.index)
}
resource "aws_route" "vpn-rt" {
  count = length(aws_subnet.vpn-subnets)
  destination_cidr_block = "0.0.0.0/0"
  route_table_id = aws_route_table.vpn-rt.id
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_network_acl" "vpn-acl" {
  vpc_id = aws_vpc.vpn-vpc.id
  subnet_ids = aws_subnet.vpn-subnets.*.id
  tags = merge({Name="vpn-acl"},local.common_tags)
}

resource "aws_network_acl_rule" "ssh-ingress" {
  network_acl_id = aws_network_acl.vpn-acl.id
  protocol = "tcp"
  rule_action = "allow"
  rule_number = 1000
  from_port = 22
  to_port = 22
  cidr_block = var.my_ip
}

resource "aws_network_acl_rule" "ssh-egress" {
  network_acl_id = aws_network_acl.vpn-acl.id
  protocol = "tcp"
  egress = true
  rule_action = "allow"
  rule_number = 1000
  from_port = 22
  to_port = 22
  cidr_block = var.my_ip
}

resource "aws_network_acl_rule" "ephemeral-ingress-tcp" {
  network_acl_id = aws_network_acl.vpn-acl.id
  egress = false
  protocol = "tcp"
  rule_action = "allow"
  rule_number = 1001
  cidr_block = "0.0.0.0/0"
  from_port = 1024
  to_port = 65535
}

resource "aws_network_acl_rule" "ephemeral-ingress-udp" {
  network_acl_id = aws_network_acl.vpn-acl.id
  protocol = "udp"
  egress = false
  rule_action = "allow"
  rule_number = 1002
  cidr_block = "0.0.0.0/0"
  from_port = 1024
  to_port = 65535
}

resource "aws_network_acl_rule" "ephermal-outbound-tcp" {
  network_acl_id = aws_network_acl.vpn-acl.id
  protocol = "tcp"
  egress = true
  rule_action = "allow"
  rule_number = 1001
  cidr_block = "0.0.0.0/0"
  from_port = 1024
  to_port = 65535
}

resource "aws_network_acl_rule" "ephermal-outbound-udp" {
  network_acl_id = aws_network_acl.vpn-acl.id
  protocol = "udp"
  rule_action = "allow"
  egress = true
  rule_number = 1002
  cidr_block = "0.0.0.0/0"
  from_port = 1024
  to_port = 65535
}

resource "aws_network_acl_rule" "openvpn-admin-ingress" {
  network_acl_id = aws_network_acl.vpn-acl.id
  protocol = "tcp"
  rule_action = "allow"
  rule_number = 1003
  from_port = 943
  to_port = 943
  cidr_block = var.my_ip
}

resource "aws_network_acl_rule" "openvpn-admin-egress" {
  network_acl_id = aws_network_acl.vpn-acl.id
  protocol = "tcp"
  egress = true
  rule_action = "allow"
  rule_number = 1003
  from_port = 943
  to_port = 943
  cidr_block = var.my_ip
}

resource "aws_network_acl_rule" "openvpn-https-ingress" {
  network_acl_id = aws_network_acl.vpn-acl.id
  protocol = "tcp"
  rule_action = "allow"
  rule_number = 1004
  from_port = 443
  to_port = 443
  cidr_block = var.my_ip
}

resource "aws_network_acl_rule" "openvpn-https-egress" {
  network_acl_id = aws_network_acl.vpn-acl.id
  protocol = "tcp"
  egress = true
  rule_action = "allow"
  rule_number = 1004
  from_port = 443
  to_port = 443
  cidr_block = var.my_ip
}

resource "aws_network_acl_rule" "vpn-outbound-udp" {
  network_acl_id = aws_network_acl.vpn-acl.id
  protocol = "udp"
  rule_action = "allow"
  egress = true
  rule_number = 1005
  cidr_block = "0.0.0.0/0"
  from_port = 1194
  to_port = 1194
}

resource "aws_network_acl_rule" "vpn-inbound-udp" {
  network_acl_id = aws_network_acl.vpn-acl.id
  protocol = "udp"
  rule_action = "allow"
  egress = false
  rule_number = 1005
  cidr_block = "0.0.0.0/0"
  from_port = 1194
  to_port = 1194
}

resource "aws_network_acl_rule" "vpn-outbound-all" {
  network_acl_id = aws_network_acl.vpn-acl.id
  protocol = "-1"
  rule_action = "allow"
  egress = true
  rule_number = 1006
  cidr_block = "0.0.0.0/0"
}

resource "aws_eip" "vpn-instance-eip" {
  vpc = true
  depends_on = [aws_internet_gateway.igw]
  instance = aws_instance.vpn-instance.id
  tags = merge({Name="vpn-eip"},local.common_tags)
}

resource "aws_ec2_transit_gateway" "dev-tgw" {
  description = "dev-tgw-1"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "dev-vpc-attachment" {
  subnet_ids                                      = aws_subnet.vpn-subnets.*.id
  transit_gateway_id                              = aws_ec2_transit_gateway.dev-tgw.id
  vpc_id                                          = aws_vpc.vpn-vpc.id
  transit_gateway_default_route_table_association = false
}

resource "aws_ec2_transit_gateway_route_table" "dev-tgw-rtb" {
  transit_gateway_id = aws_ec2_transit_gateway.dev-tgw.id
}

resource "aws_ec2_transit_gateway_route" "dev-vpn-route" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.dev-vpc-attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.dev-tgw-rtb.id
}