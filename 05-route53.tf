resource "aws_route53_zone" "private"{
  name = "openvpn.com"

  vpc {
    vpc_id = aws_vpc.vpn-vpc.id
  }

  tags = merge({
    Name="vpn-private-hosted-zone"
  },
    local.common_tags
  )
}
