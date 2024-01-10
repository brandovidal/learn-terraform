terraform {
  backend "s3" {
    bucket  = "terraform-codely-tf-states"
    key     = "apps/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
