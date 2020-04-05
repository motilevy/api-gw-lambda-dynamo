locals {
  subnets = cidrsubnets(var.cidr, 4, 4, 2, 2)
}

resource "aws_subnet" "prv" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(local.subnets, count.index)
  availability_zone       = join("", [var.region, element(var.azs, count.index)])
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.name}-private-az${count.index + 1}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table" "prv" {
  count  = 2
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.name}-private-az${count.index + 1}"
    vpc  = aws_vpc.main.id
  }
}

resource "aws_route_table_association" "prv" {
  count          = 2
  subnet_id      = aws_subnet.prv[count.index].id
  route_table_id = aws_route_table.prv[count.index].id
}

resource "aws_subnet" "pub" {
  count                   = var.vpc_type == "external" ? 2 : 0
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(local.subnets, count.index + 2)
  availability_zone       = join("", [var.region, element(var.azs, count.index)])
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.name}-public-az${count.index + 1}"
  }
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_route_table" "pub" {
  count  = var.vpc_type == "external" ? 1 : 0
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.name}-public"
    vpc  = aws_vpc.main.id
  }
}

resource "aws_route_table_association" "pub" {
  count          = var.vpc_type == "external" ? 2 : 0
  subnet_id      = aws_subnet.pub[count.index].id
  route_table_id = aws_route_table.pub.0.id
}


output "prv_subnets" {
  value = aws_subnet.prv.*.id
}
