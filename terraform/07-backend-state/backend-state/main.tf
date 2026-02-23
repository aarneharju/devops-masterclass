terraform {
  required_providers {
    infisical = {
      source = "infisical/infisical"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.26"
    }
  }
}

variable "infisical_client_id" {
  type        = string
  sensitive   = true
  description = "Infisical Machine Identity Client ID"
}

variable "infisical_client_secret" {
  type        = string
  sensitive   = true
  description = "Infisical Machine Identity Client Secret"
}

variable "infisical_project_id" {
  type        = string
  sensitive   = true
  description = "Infisical Project ID"
}

provider "infisical" {
  host          = "https://eu.infisical.com/"
  client_id     = var.infisical_client_id
  client_secret = var.infisical_client_secret
}

# Fetch AWS credentials from Infisical
ephemeral "infisical_secret" "aws_access" {
  name         = "AWS_ADMIN_CLI_ACCESS_KEY"
  env_slug     = "prod"
  workspace_id = var.infisical_project_id
  folder_path  = "/"
}

ephemeral "infisical_secret" "aws_secret" {
  name         = "AWS_ADMIN_CLI_SECRET_ACCESS_KEY"
  env_slug     = "prod"
  workspace_id = var.infisical_project_id
  folder_path  = "/"
}

provider "aws" {
  region     = "eu-north-1"
  access_key = ephemeral.infisical_secret.aws_access.value
  secret_key = ephemeral.infisical_secret.aws_secret.value
}

//S3 bucket
resource "aws_s3_bucket" "enterprise_backend_state" {
    bucket = "dev-all-applications-backend-state-ahoy"

    lifecycle {
        prevent_destroy = true
    }
}

resource "aws_s3_bucket_versioning" "versioning_for_backend_state" {
  bucket = aws_s3_bucket.enterprise_backend_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# We need to encrypt the state if you have for example database passwords stored in the state
resource "aws_s3_bucket_server_side_encryption_configuration" "sse_for_backend_state" {
  bucket = aws_s3_bucket.enterprise_backend_state.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}
