resource "aws_internet_gateway" "flask_igw" {
  vpc_id = var.vpc_id 

  tags = {
    Name = "flask-app-igw"
  }
}

resource "aws_route_table" "flask_route_table" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.flask_igw.id
  }
  tags = {
    Name = "flask-public-route-table"
  }
}

resource "aws_route_table_association" "public_subnet" {
  subnet_id = var.subnet_id
  route_table_id = aws_route_table.flask_route_table.id
  
}