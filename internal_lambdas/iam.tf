resource "aws_iam_role" "role" {
  name               = "internal-${var.name}"
  description        = "role for internal lambdas"
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


data "aws_iam_policy_document" "lambda" {
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
    sid = "AllowDynamo"

    actions = [
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:Scan",
      "dynamodb:Query",
      "dynamodb:UpdateItem"
    ]
    resources = [var.table_arn]
  }

  statement {
    sid = "AllowDynamoList"

    actions = [
      "dynamodb:ListTables"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "lambda" {
  name        = "internal-lambda-${var.name}"
  description = "policy for internal lambda"
  policy      = data.aws_iam_policy_document.lambda.json
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.lambda.arn
}

