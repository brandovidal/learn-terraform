include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../src"
}

inputs = {
  bucket_name    = "brandovidal-serverless-deploys"
  lambda_role    = "lambda-backoffice-role"
  function_name    = "lambda-backoffice-api"
  apigateway_name    = "serverless-backoffice-api"
  handler_dir    = "${path_relative_from_include()}/../../../../tmp"
}