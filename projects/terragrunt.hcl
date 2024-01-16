locals {
  project_name = "backoffice"
}

inputs = {
  backend_name    = "serverless-deploys-tf-states"
  bucket_name     = "brandovidal-serverless-deploys"
  folder_name     = "serverless-${local.project_name}"
  lambda_role     = "lambda-${local.project_name}-role"
  function_name   = "lambda-${local.project_name}-api"
  apigateway_name = "serverless-${local.project_name}-api"
  handler_dir     = "${path_relative_from_include()}/build"
}

terraform {
  extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()

    optional_var_files = [
      "${find_in_parent_folders("env.tfvars", "skip-env-if-does-not-exist")}"
    ]
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.31.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.4.1"
    }
  }
}
provider "aws" {
  profile = "default"
  region  = "us-east-1"
}
EOF
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket  = "serverless-deploys-tf-states"
    key     = "${path_relative_to_include()}/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    disable_bucket_update = true
  }
}
