resource "aws_iam_role" "external" {
  name               = "external-${var.name}"
  description        = "role for external lambdas"
  assume_role_policy = data.aws_iam_policy_document.sts.json
}

data "aws_iam_policy_document" "sts" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}


data "aws_iam_policy_document" "external" {
  statement {
    sid = "AllowLambda"

    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }

  statement {
    sid = "AllowInvoke"

    actions = [
      "lambda:InvokeFunction"
    ]

    resources = var.internal_lambdas_arns
  }
}

resource "aws_iam_policy" "external" {
  name        = "external-lambda-${var.name}"
  description = "policy for external lambda"
  policy      = data.aws_iam_policy_document.external.json
}

resource "aws_iam_role_policy_attachment" "external" {
  role       = aws_iam_role.external.name
  policy_arn = aws_iam_policy.external.arn
}

