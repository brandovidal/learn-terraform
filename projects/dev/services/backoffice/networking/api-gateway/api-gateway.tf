locals {
  apigateway_name           = "${var.apigateway_name}-${var.env}"
  function_name             = "${var.function_name}-${var.env}"
  cloudwatch_log_group_name = "/aws/api-gw/${local.apigateway_name}"
}
resource "aws_apigatewayv2_api" "serverless_api" {
  name          = local.apigateway_name
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
    allow_headers = ["*"]
  }

  tags = {
    environment = var.env_name
    name        = var.apigateway_name
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
  name              = local.cloudwatch_log_group_name
  retention_in_days = 30
  tags = {
    environment = var.env_name
    name        = local.cloudwatch_log_group_name
  }
}

data "terraform_remote_state" "remote_lambda" {
  backend = "s3"
  config = {
    bucket = var.backend_name
    key    = "dev/services/backoffice/compute/lambda/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_apigatewayv2_integration" "lambda_handler" {
  api_id = aws_apigatewayv2_api.serverless_api.id

  integration_type = "AWS_PROXY"
  # integration_method = "ANY"
  integration_uri        = data.terraform_remote_state.remote_lambda.outputs.lambda_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "serverless_api_route" {
  api_id    = aws_apigatewayv2_api.serverless_api.id
  route_key = "$default"

  target = "integrations/${aws_apigatewayv2_integration.lambda_handler.id}"
}

resource "aws_lambda_permission" "handler_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = local.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.serverless_api.execution_arn}/*"
}
