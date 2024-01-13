include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../src"
}

inputs = {
  bucket_name    = "terraform-codely-bucket-dev"
  handler_dir    = "${path_relative_from_include()}/../app"
}