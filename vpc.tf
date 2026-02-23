resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = merge(local.common_tags, { Name = "MainVPC" })
}

resource "aws_subnet" "private" {
  count = length(var.subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false # Privadas

  tags = merge(local.common_tags, { Name = "PrivateSubnet${count.index + 1}" })
}