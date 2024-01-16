include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../src"
}

locals {
  project_name = "backoffice"
  env          = "dev"
}

inputs = {
  bucket_name     = "brandovidal-serverless-deploys"
  lambda_role     = "lambda-${local.project_name}-role"
  function_name   = "lambda-${local.project_name}-api"
  apigateway_name = "serverless-${local.project_name}-api"
  handler_dir     = "${path_relative_from_include()}/../../../../tmp"
}