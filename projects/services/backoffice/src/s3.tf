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
  key    = "${var.env}/${var.bucket_name}/handler.zip"
  source = data.archive_file.handler.output_path
  etag   = filemd5(data.archive_file.handler.output_path)
}
