resource "aws_network_acl" "prv" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.prv.*.id
  tags = {
    Name = "${var.name}-private"
  }
}

resource "aws_network_acl" "pub" {
  count      = var.vpc_type == "external" ? 1 : 0
  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.pub.*.id
  tags = {
    Name = "${var.name}-public"
  }
}

# allow outbound https access
resource "aws_network_acl_rule" "pub_egress_https" {
  count          = var.vpc_type == "external" ? 1 : 0
  network_acl_id = aws_network_acl.pub[count.index].id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  from_port      = 443
  to_port        = 443
  cidr_block     = "0.0.0.0/0"
}

# allow return traffic into the vpc
resource "aws_network_acl_rule" "pub_egress_ephemral" {
  count          = var.vpc_type == "external" ? 1 : 0
  network_acl_id = aws_network_acl.pub[count.index].id
  rule_number    = 101
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  from_port      = 1024
  to_port        = 65535
  cidr_block     = var.cidr
}

resource "aws_network_acl_rule" "pub_ingress_ephemeral" {
  count          = var.vpc_type == "external" ? 1 : 0
  network_acl_id = aws_network_acl.pub[count.index].id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_ingress_https" {
  count          = var.vpc_type == "external" ? 1 : 0
  network_acl_id = aws_network_acl.pub[count.index].id
  rule_number    = 101
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  from_port      = 443
  to_port        = 443
  cidr_block     = var.cidr
}

resource "aws_network_acl_rule" "prv_egress_https" {
  network_acl_id = aws_network_acl.prv.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  from_port      = 443
  to_port        = 443
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "prv_ingress_ephemeral" {
  network_acl_id = aws_network_acl.prv.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}
