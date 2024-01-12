include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../src"
}

inputs = {
  bucket_name    = "terraform-codely-bucket-dev"
  read_capacity  = 1
  write_capacity = 1
}