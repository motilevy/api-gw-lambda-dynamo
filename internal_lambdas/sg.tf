resource "aws_security_group" "lambda" {
  name        = "lambda-${var.name}"
  description = "Security Group for lambda-${var.name}"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr]
  }

  tags = {
    Name = "lambda-${var.name}"
  }
}

