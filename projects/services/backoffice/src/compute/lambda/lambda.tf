#  AWS Lambda
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

resource "aws_lambda_function" "handler_api" {
  function_name = "${var.function_name}-${var.env}"

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

# // tfstate output
output "lambda_arn" {
  value = aws_lambda_function.handler_api.arn
}
