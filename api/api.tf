# create the api
data "aws_caller_identity" "current" {}

locals {
  lambdas = ["get", "put", "delete"]
}
resource "aws_api_gateway_rest_api" "api" {
  name = "api-${var.name}"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# root resources
# resource "aws_api_gateway_method" "root" {
#   for_each      = { for x in local.lambdas : x => x }
#   rest_api_id   = aws_api_gateway_rest_api.api.id
#   resource_id   = aws_api_gateway_rest_api.api.root_resource_id
#   http_method   = upper(each.value)
#   authorization = "NONE"
#
#
resource "aws_api_gateway_resource" "resource" {
  for_each    = { for x in sort(local.lambdas) : x => x }
  path_part   = each.value
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_method" "method" {
  for_each      = { for x in sort(local.lambdas) : x => x }
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource[each.value].id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  for_each    = { for x in local.lambdas : x => x }
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_method.method[each.value].resource_id
  http_method = aws_api_gateway_method.method[each.value].http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.external_lambdas[each.value].invoke_arn
}


resource "aws_lambda_permission" "integration" {
  for_each      = { for x in local.lambdas : x => x }
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.external_lambdas[each.value].function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.method[each.value].http_method}/*"
}

resource "aws_api_gateway_deployment" "api" {
  depends_on = [
    aws_api_gateway_integration.integration,
    aws_lambda_permission.integration
  ]

  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "v1"
}

output "url" {
  value = aws_api_gateway_deployment.api.invoke_url
}
