data "aws_vpc_endpoint_service" "dynamodb" {
  count   = var.vpc_type == "internal" ? 1 : 0
  service = "dynamodb"
}

resource "aws_vpc_endpoint" "dynamodb" {
  count        = var.vpc_type == "internal" ? 1 : 0
  vpc_id       = aws_vpc.main.id
  service_name = data.aws_vpc_endpoint_service.dynamodb[0].service_name
  tags = {
    Name = "${var.name}"
  }
}

resource "aws_vpc_endpoint_route_table_association" "dynamodb" {
  count           = var.vpc_type == "internal" ? 2 : 0
  vpc_endpoint_id = aws_vpc_endpoint.dynamodb[0].id
  route_table_id  = aws_route_table.prv[count.index].id
}
