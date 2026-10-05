output "bucket_name" {
  description = "The dynamically allocated S3 bucket name"
  value       = aws_s3_bucket.sandbox_storage.id
}

output "log_group_name" {
  description = "CloudWatch log group created for the sandbox"
  value       = aws_cloudwatch_log_group.sandbox_logs.name
}