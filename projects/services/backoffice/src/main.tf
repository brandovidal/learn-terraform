resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "lambda_bucket" {
  bucket = aws_s3_bucket.lambda_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "archive_file" "handler" {
  type        = "zip"
  source_dir  = var.handler_dir
  output_path = "handler.zip"
}

resource "aws_s3_object" "handler" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "${var.env}/handler.zip"
  source = data.archive_file.handler.output_path
  etag   = filemd5(data.archive_file.handler.output_path)
}

#  AWS Lambda
resource "aws_iam_role" "handler_lambda_role" {
  name = var.lambda_role
  # name = "handler-lambda"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}
resource "aws_iam_role_policy_attachment" "handler_lambda_policy" {
  role       = aws_iam_role.handler_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "handler_api" {
  function_name = var.function_name
  # function_name = "handler"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.handler.key

  runtime = "nodejs18.x"
  handler = "lambda.handler"

  source_code_hash = data.archive_file.handler.output_base64sha256

  role = aws_iam_role.handler_lambda_role.arn
}


resource "aws_cloudwatch_log_group" "handler_lambda" {
  name = "/aws/lambda/${aws_lambda_function.handler_api.function_name}-${var.env}"
}

# AWS API Gateway
resource "aws_apigatewayv2_api" "serverless_api" {
  name          = var.apigateway_name
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
  integration_uri  = aws_lambda_function.handler_api.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "post_handler" {
  api_id    = aws_apigatewayv2_api.serverless_api.id
  route_key = "$default"

  target = "integrations/${aws_apigatewayv2_integration.lambda_handler.id}"
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.handler_api.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.serverless_api.execution_arn}/*"
}
