variable "bucket_name"{
  description = "The name of the S3 bucket. Must be globally unique."
  type        = string
}
variable "lambda_role"{}
variable "function_name"{}
variable "apigateway_name"{}
variable "env"{}
variable "handler_dir"{}