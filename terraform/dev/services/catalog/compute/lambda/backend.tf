terraform {
  backend "s3" {
    bucket  = "terraform-codely-tf-states"
    key     = "dev/services/catalog/compute/lambda/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
