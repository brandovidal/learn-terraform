output "lambda_arn" {
  value = aws_lambda_function.handler_api.arn
}
output "lambda_function_url" {
  value = aws_lambda_function_url.handler_api_url.function_url
}
