resource "aws_s3_bucket" "example_bucket" {
  bucket = var.bucket_name

  tags = {
    Environment = "Dev"
    Project     = "Codely course"
  }
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.example_bucket.id
  key    = "hello-world"
  source = "hello-world.html"

  content_type = "text/html"
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.example_bucket.id
  policy = data.aws_iam_policy_document.main.json
  
  depends_on = [aws_s3_bucket_public_access_block.example]
}

data "aws_iam_policy_document" "main" {
  version = "2012-10-17"

  statement {
    sid = "AllowBucketAccess"

    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]
    resources = [
      aws_s3_bucket.example_bucket.arn,
      "${aws_s3_bucket.example_bucket.arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

data "archive_file" "catalog_writer" {
  type = "zip"

  source_dir  = "${path.module}/src"
  output_path = "${path.module}/catalog-writer.zip"
}
