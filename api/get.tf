# resource "aws_api_gateway_method" "get" {
#   rest_api_id   = aws_api_gateway_rest_api.api.id
#   resource_id   = aws_api_gateway_resource.music.id
#   http_method   = "GET"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "get" {
#   rest_api_id = aws_api_gateway_rest_api.api.id
#   resource_id = aws_api_gateway_method.get.resource_id
#   http_method = aws_api_gateway_method.get.http_method

#   integration_http_method = "GET"
#   type                    = "AWS_PROXY"
#   uri                     = var.external_lambdas["get"].invoke_arn
# }

# resource "aws_lambda_permission" "get" {
#   statement_id  = "AllowAPIGatewayInvoke"
#   action        = "lambda:InvokeFunction"
#   function_name = var.external_lambdas["get"].function_name
#   principal     = "apigateway.amazonaws.com"
#   source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/GET/*"
#   # source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.get.http_method}${aws_api_gateway_resource.music.path}"

# }

