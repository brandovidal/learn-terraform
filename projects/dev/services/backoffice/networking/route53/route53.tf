locals {
  subdomain   = "api"
  record_name = "${local.subdomain}.brandovidal.dev"
}
data "aws_route53_zone" "main" {
  name         = local.record_name
  private_zone = false

  tags = {
    Environment = var.env_name
    Name        = local.record_name
  }
}
data "terraform_remote_state" "remote_s3" {
  backend = "s3"
  config = {
    bucket = var.backend_name
    key    = "dev/services/backoffice/networking/api-gateway/terraform.tfstate"
    region = "us-east-1"
  }
}
resource "aws_route53_record" "custom_domain_record" {
  name = local.subdomain
  type = "CNAME"
  ttl  = "300"

  records = ["${data.terraform_remote_state.remote_s3.outputs.base_url}.execute-api.us-east-1.amazonaws.com"]

  zone_id = data.aws_route53_zone.main.zone_id
}

resource "aws_acm_certificate" "api_cert" {
  domain_name               = local.record_name
  subject_alternative_names = [local.record_name]
  validation_method         = "DNS"
}
