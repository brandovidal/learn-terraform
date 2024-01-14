

# AWS API Gateway
resource "aws_apigatewayv2_api" "serverless_api" {
  name = var.apigateway_name
  # name          = "main"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
    allow_headers = ["*"]
  }
}

resource "aws_apigatewayv2_stage" "serverless_stage" {
  api_id = aws_apigatewayv2_api.serverless_api.id

  name        = "$default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.serverless_api_log.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_cloudwatch_log_group" "serverless_api_log" {
  name = "/aws/api-gw/${aws_apigatewayv2_api.serverless_api.name}-${var.env}"

  retention_in_days = 30
}
resource "aws_apigatewayv2_integration" "lambda_handler" {
  api_id = aws_apigatewayv2_api.serverless_api.id

  integration_type = "AWS_PROXY"
  # integration_method = "ANY"
  integration_uri        = aws_lambda_function.handler_api.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "post_handler" {
  api_id    = aws_apigatewayv2_api.serverless_api.id
  route_key = "$default"

  target = "integrations/${aws_apigatewayv2_integration.lambda_handler.id}"
}

output "base_url" {
  description = "Base URL for API Gateway stage."

  value = aws_apigatewayv2_stage.serverless_stage.invoke_url
}

resource "aws_lambda_permission" "handler_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.handler_api.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.serverless_api.execution_arn}/*"
}
