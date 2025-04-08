resource "aws_eip" "flask_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "flask_nat_gw" {
  allocation_id = aws_eip.flask_eip.id
  subnet_id = var.public_subnet_id

  tags = {
    Name = "flask-NAT-GW"
  }
}

resource "aws_route_table" "flask_private_route_table" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.flask_nat_gw.id
  }

  tags = {
    Name = "flask-private-route-table"
  }
}

resource "aws_route_table_association" "flask_route_table_private_subnet" {
  subnet_id = var.private_subnet_id
  route_table_id = aws_route_table.flask_private_route_table.id
}