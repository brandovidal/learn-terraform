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

locals {
  bucket_key = "${var.env}/${var.folder_name}/handler.zip"
}

resource "aws_s3_object" "handler" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = local.bucket_key
  source = data.archive_file.handler.output_path
  etag   = filemd5(data.archive_file.handler.output_path)

  tags = {
    environment = var.env_name
    name        = var.folder_name
  }
}

output "bucket_id" {
  value = aws_s3_bucket.lambda_bucket.id
}

output "bucket_key" {
  value = local.bucket_key
}

output "source_code_hash" {
  value = data.archive_file.handler.output_base64sha256
}