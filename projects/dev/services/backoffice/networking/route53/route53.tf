# data "aws_route53_zone" "main" {
#   name = "brandovidal.dev"
#   private_zone = false

#   tags = {
#     Environment = var.env
#   }
# }
# resource "aws_route53_record" "custom_domain_record" {
#   name = "api" # The subdomain (api.brandovidal.dev)
#   type = "CNAME"
#   ttl = "300" # TTL in seconds

#   records = ["${aws_apigatewayv2_api.serverless_api.id}.execute-api.us-east-1.amazonaws.com"]

#   zone_id = data.aws_route53_zone.main.zone_id
# }

# resource "aws_acm_certificate" "my_api_cert" {
#   domain_name = "api.brandovidal.dev"
#   # provider = aws.aws_useast1 # needs to be in US East 1 region
#   subject_alternative_names = ["api.brandovidal.dev"] # Your custom domain
#   validation_method = "DNS"
# }