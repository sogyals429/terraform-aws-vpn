resource "aws_security_group" "vpn-instance-sg" {
  name = "vpn-instance-sg"
  description = "SG for VPN Instance"
  vpc_id = aws_vpc.vpn-vpc.id
  tags = merge({Name="vpn-instance-sg"},local.common_tags)
}

resource "aws_security_group_rule" "ssh-ingress" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_block = "103.44.33.69/32"
  security_group_id = aws_security_group.vpn-instance-sg.id
  description = "Allow ssh inbound from Unilodge"
}

resource "aws_security_group_rule" "ssh-egress" {
  type = "egress"
  protocol = "tcp"
  rule_number = 1000
  from_port = 22
  to_port = 22
  cidr_block = "103.44.33.69/32"
  security_group_id = aws_security_group.vpn-instance-sg.id
  description = "Allow ssh outbound from Unilodge"
}


resource "aws_security_group_rule" "openvpn-admin-ingress" {
  type = "ingress"
  protocol = "tcp"
  from_port = 943
  to_port = 943
  cidr_block = "103.44.33.69/32"
  security_group_id = aws_security_group.vpn-instance-sg.id
  description = "Allow vpn portal inbound from Unilodge"
}

resource "aws_security_group_rule" "openvpn-admin-egress" {
  type = "egress"
  protocol = "tcp"
  from_port = 943
  to_port = 943
  cidr_block = "103.44.33.69/32"
  security_group_id = aws_security_group.vpn-instance-sg.id
  description = "Allow vpn portal outbound from Unilodge"
}

resource "aws_security_group_rule" "openvpn-https-ingress" {
  type = "ingress"
  protocol = "tcp"
  from_port = 443
  to_port = 443
  cidr_block = "103.44.33.69/32"
  security_group_id = aws_security_group.vpn-instance-sg.id
  description = "Allow https portal inbound from Unilodge"
}

resource "aws_security_group_rule" "openvpn-https-egress" {
  type = "egress"
  protocol = "tcp"
  from_port = 443
  to_port = 443
  cidr_block = "103.44.33.69/32"
  security_group_id = aws_security_group.vpn-instance-sg.id
  description = "Allow https portal outbound from Unilodge"
}

resource "aws_security_group_rule" "vpn-inbound-udp" {
  type = "ingress"
  protocol = "udp"
  from_port = 1194
  to_port = 1194
  cidr_block = "0.0.0.0/0"
  security_group_id = aws_security_group.vpn-instance-sg.id
  description = "Allow to connect to vpn inbound"
}

resource "aws_security_group_rule" "vpn-outbound-udp" {
  type = "egress"
  protocol = "udp"
  from_port = 1194
  to_port = 1194
  cidr_block = "0.0.0.0/0"
  security_group_id = aws_security_group.vpn-instance-sg.id
  description = "Allow to connect to vpn outbound"
}
