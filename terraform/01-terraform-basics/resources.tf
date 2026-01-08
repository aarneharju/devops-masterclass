resource "aws_iam_user" "terraform_created_user" {
  name = "terraform-created-user-with-updated-name"
}

resource "aws_s3_bucket" "terraform_bucket" {
  bucket = "devops-masterclass-bucket-002"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
