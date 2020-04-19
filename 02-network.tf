resource "aws_vpc" "vpn-vpc" {
  cidr_block = var.vpc_cidr
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