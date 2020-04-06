locals {
  lambdas = ["get", "put", "delete"]
}


data "archive_file" "zip" {
  for_each    = { for x in local.lambdas : x => x }
  type        = "zip"
  source_dir  = "${path.module}/src/${each.value}"
  output_path = "${path.module}/zip/${each.value}.zip"
}

resource "aws_lambda_function" "func" {
  for_each         = { for x in local.lambdas : x => x }
  function_name    = "${each.value}-internal-${var.name}"
  role             = aws_iam_role.internal.arn
  handler          = "main.lambda_handler"
  description      = "${each.value} function"
  runtime          = "python3.7"
  filename         = "${path.module}/zip/${each.value}.zip"
  source_code_hash = filebase64sha256("${path.module}/zip/${each.value}.zip")
  memory_size      = 128
  timeout          = 30

  vpc_config {
    subnet_ids         = var.subnets
    security_group_ids = [aws_security_group.lambda.id]
  }

  environment {
    variables = {
      TABLE = var.table_name
    }
  }
  depends_on = [aws_security_group.lambda, aws_iam_role.internal, aws_iam_role_policy_attachment.internal]
}
output "all" {
  value = aws_lambda_function.func
}

output "arn_map" {
  value = {
    for lambda in aws_lambda_function.func :
    lambda.id => lambda.arn
  }
}

output "arn_list" {
  value = [
    for lambda in aws_lambda_function.func :
    lambda.arn
  ]
}
