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

