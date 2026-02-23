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

  backend "s3" {
    bucket = "dev-all-applications-backend-state-ahoy"
    key = "07-backend-state-terraform-project-1-users-dev" # app name - project name - environment name is a good pattern here, you can also use them with variables if you have created them: "${var.application_name}-${var.project_name}-${var.environment_name}"
    region = "eu-north-1"
    use_lockfile = true
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
