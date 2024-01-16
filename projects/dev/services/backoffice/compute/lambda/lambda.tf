#  AWS Lambda
locals {
  function_name             = "${var.function_name}-${var.env}"
  cloudwatch_log_group_name = "/aws/lambda/${local.function_name}"
}

resource "aws_iam_role" "handler_lambda_role" {
  name = var.lambda_role

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

data "terraform_remote_state" "remote_s3" {
  backend = "s3"
  config = {
    bucket = var.backend_name
    key    = "dev/services/backoffice/storage/s3/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_lambda_function" "handler_api" {
  function_name = local.function_name

  s3_bucket = var.bucket_name
  s3_key    = data.terraform_remote_state.remote_s3.outputs.bucket_key

  runtime = "nodejs18.x"
  handler = "lambda.handler"

  source_code_hash = data.terraform_remote_state.remote_s3.outputs.source_code_hash

  role = aws_iam_role.handler_lambda_role.arn

  tags = {
    environment = var.env_name
    name        = var.function_name
  }
}

resource "aws_cloudwatch_log_group" "handler_lambda" {
  name              = local.cloudwatch_log_group_name
  retention_in_days = 30
  tags = {
    environment = var.env_name
    name        = local.cloudwatch_log_group_name
  }
}
