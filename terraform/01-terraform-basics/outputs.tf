output "aws_s3_bucket_versioning_status" {
  value = aws_s3_bucket.terraform_bucket.versioning.0.enabled
}

output "aws_s3_bucket_name" {
  value = aws_s3_bucket.terraform_bucket.bucket
}

output "aws_iam_terraform_created_user_complete_details" {
  value = aws_iam_user.terraform_created_user
}
