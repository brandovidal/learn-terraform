data "archive_file" "handler" {
  type        = "zip"
  source_dir  = var.handler_dir
  output_path = "handler.zip"
}

locals {
  bucket_key = "${var.env}/${var.folder_name}/handler.zip"
}

resource "aws_s3_object" "handler" {
  bucket = var.bucket_name
  key    = local.bucket_key
  source = data.archive_file.handler.output_path
  etag   = filemd5(data.archive_file.handler.output_path)

  tags = {
    environment = var.env_name
    name        = var.folder_name
  }
}
