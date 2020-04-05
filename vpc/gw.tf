resource "aws_internet_gateway" "main" {
  count  = var.vpc_type == "external" ? 1 : 0
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.name}-igw"
  }
}

resource "aws_route" "igw" {
  count                  = var.vpc_type == "external" ? 1 : 0
  route_table_id         = aws_route_table.pub.0.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.0.id
}

resource "aws_eip" "main" {
  count = var.vpc_type == "external" ? 2 : 0
  vpc   = true
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "${var.name}-nat-gatway-az${count.index}"
  }
}

resource "aws_nat_gateway" "main" {
  count         = var.vpc_type == "external" ? 2 : 0
  allocation_id = aws_eip.main[count.index].id
  subnet_id     = aws_subnet.pub[count.index].id
  depends_on    = [aws_internet_gateway.main]
  tags = {
    Name = "${var.name}-nat-gatway-az${count.index + 1}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route" "nat_gateway" {
  count                  = var.vpc_type == "external" ? 2 : 0
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.prv[count.index].id
  nat_gateway_id         = aws_nat_gateway.main[count.index].id
}
