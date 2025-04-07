resource "aws_subnet" "public" {
  for_each = {for idx, cidr in var.public_subnet_cidrs : idx => cidr}

  cidr_block = each.value
  availability_zone = var.public_azs[each.key]
  vpc_id = var.vpc_id
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.subnet_name}-public-${each.key}"
  }
}

resource "aws_subnet" "private" {
  for_each = { for idx, cidr in var.private_subnet_cidrs : idx => cidr }

  cidr_block        = each.value
  availability_zone = var.private_azs[each.key]
  vpc_id            = var.vpc_id

  tags = {
    Name = "${var.subnet_name}-private-${each.key}"
  }
}