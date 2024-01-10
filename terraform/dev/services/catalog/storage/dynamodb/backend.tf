terraform {
  backend "s3" {
    bucket  = "terraform-codely-tf-states"
    key     = "dev/services/catalog/storage/dynamodb/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
