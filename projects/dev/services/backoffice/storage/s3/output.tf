output "bucket_key" {
  value = local.bucket_key
}

output "source_code_hash" {
  value = data.archive_file.handler.output_base64sha256
}
