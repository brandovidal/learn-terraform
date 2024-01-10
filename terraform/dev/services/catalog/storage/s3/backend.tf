terraform {
  backend "s3" {
    bucket  = "terraform-codely-tf-states"
    key     = "dev/services/catalog/storage/s3/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
